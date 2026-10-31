package auth

import (
	"bytes"
	"encoding/json"
	"github.com/golang-jwt/jwt/v5"
	bolt "go.etcd.io/bbolt"
	"golang.org/x/crypto/bcrypt"
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"
)

func serviceForTest(t *testing.T) *Service {
	t.Helper()
	s, err := Open(filepath.Join(t.TempDir(), "auth.db"), bytes.Repeat([]byte{42}, 32))
	if err != nil {
		t.Fatal(err)
	}
	s.passwordCost = bcrypt.MinCost
	t.Cleanup(func() { _ = s.Close() })
	return s
}

const password = "A-long-test-password"

func mustRegister(t *testing.T, s *Service, email string) Tokens {
	t.Helper()
	r, e := s.Register(email, password)
	if e != nil {
		t.Fatal(e)
	}
	return r
}
func TestRotationReplayAndRevocation(t *testing.T) {
	s := serviceForTest(t)
	first := mustRegister(t, s, "USER@example.com")
	u, _, err := s.Authenticate(first.AccessToken)
	if err != nil || u.Email != "user@example.com" {
		t.Fatalf("initial auth: %+v %v", u, err)
	}
	second, err := s.Refresh(first.RefreshToken)
	if err != nil || second.RefreshToken == first.RefreshToken {
		t.Fatalf("rotation: %v", err)
	}
	if _, err = s.Refresh(first.RefreshToken); err != ErrUnauthorized {
		t.Fatal("replay accepted")
	}
	if _, _, err = s.Authenticate(second.AccessToken); err != ErrUnauthorized {
		t.Fatal("access survived replay revocation")
	}
	if _, err = s.Refresh(second.RefreshToken); err != ErrUnauthorized {
		t.Fatal("refresh survived revocation")
	}
	login, err := s.Login("user@example.com", password)
	if err != nil {
		t.Fatal(err)
	}
	if err = s.Logout(login.RefreshToken); err != nil {
		t.Fatal(err)
	}
	if _, _, err = s.Authenticate(login.AccessToken); err != ErrUnauthorized {
		t.Fatal("access survived logout")
	}
}
func TestJWTValidationAndExpiry(t *testing.T) {
	s := serviceForTest(t)
	now := time.Now().UTC()
	s.now = func() time.Time { return now }
	r := mustRegister(t, s, "a@example.com")
	_, sid, err := s.Authenticate(r.AccessToken)
	if err != nil {
		t.Fatal(err)
	}
	for name, c := range map[string]jwt.RegisteredClaims{
		"issuer":          {Issuer: "wrong", Audience: jwt.ClaimStrings{audience}, Subject: r.User.ID, ExpiresAt: jwt.NewNumericDate(now.Add(time.Hour))},
		"audience":        {Issuer: issuer, Audience: jwt.ClaimStrings{"wrong"}, Subject: r.User.ID, ExpiresAt: jwt.NewNumericDate(now.Add(time.Hour))},
		"expiry required": {Issuer: issuer, Audience: jwt.ClaimStrings{audience}, Subject: r.User.ID},
	} {
		t.Run(name, func(t *testing.T) {
			raw, _ := jwt.NewWithClaims(jwt.SigningMethodHS256, claims{SessionID: sid, RegisteredClaims: c}).SignedString(s.key)
			if _, _, e := s.Authenticate(raw); e != ErrUnauthorized {
				t.Fatal("invalid claims accepted")
			}
		})
	}
	validClaims := claims{SessionID: sid, RegisteredClaims: jwt.RegisteredClaims{Issuer: issuer, Audience: jwt.ClaimStrings{audience}, Subject: r.User.ID, ExpiresAt: jwt.NewNumericDate(now.Add(time.Hour))}}
	wrongKey, _ := jwt.NewWithClaims(jwt.SigningMethodHS256, validClaims).SignedString(bytes.Repeat([]byte{1}, 32))
	if _, _, e := s.Authenticate(wrongKey); e != ErrUnauthorized {
		t.Fatal("wrong signature accepted")
	}
	none, _ := jwt.NewWithClaims(jwt.SigningMethodNone, validClaims).SignedString(jwt.UnsafeAllowNoneSignatureType)
	if _, _, e := s.Authenticate(none); e != ErrUnauthorized {
		t.Fatal("none algorithm accepted")
	}
	now = now.Add(accessLifetime + time.Second)
	if _, _, e := s.Authenticate(r.AccessToken); e != ErrUnauthorized {
		t.Fatal("expired access accepted")
	}
	refreshed, e := s.Refresh(r.RefreshToken)
	if e != nil {
		t.Fatal("valid refresh after access expiry: ", e)
	}
	now = now.Add(sessionLifetime)
	if _, e = s.Refresh(refreshed.RefreshToken); e != ErrUnauthorized {
		t.Fatal("expired session accepted")
	}
}
func TestDeletionIsolatedAndSecretsHashed(t *testing.T) {
	s := serviceForTest(t)
	a := mustRegister(t, s, "a@example.com")
	b := mustRegister(t, s, "b@example.com")
	if err := s.db.View(func(tx *bolt.Tx) error {
		raw := tx.Bucket(usersBucket).Get([]byte(a.User.ID))
		if bytes.Contains(raw, []byte(password)) {
			t.Fatal("plaintext password persisted")
		}
		if tx.Bucket(refreshBucket).Get([]byte(a.RefreshToken)) != nil {
			t.Fatal("raw refresh persisted as key")
		}
		return nil
	}); err != nil {
		t.Fatal(err)
	}
	if err := s.DeleteAccount(a.User.ID, "incorrect"); err != ErrCredentials {
		t.Fatal("delete without password")
	}
	if err := s.DeleteAccount(a.User.ID, password); err != nil {
		t.Fatal(err)
	}
	if _, _, e := s.Authenticate(a.AccessToken); e != ErrUnauthorized {
		t.Fatal("deleted user access accepted")
	}
	if _, e := s.Refresh(a.RefreshToken); e != ErrUnauthorized {
		t.Fatal("deleted user refresh accepted")
	}
	if _, e := s.Login(a.User.Email, password); e != ErrCredentials {
		t.Fatal("deleted user login accepted")
	}
	if _, _, e := s.Authenticate(b.AccessToken); e != nil {
		t.Fatal("deleting one user affected another")
	}
}
func TestConcurrentRefresh(t *testing.T) {
	s := serviceForTest(t)
	a := mustRegister(t, s, "a@example.com")
	var wg sync.WaitGroup
	errors := make(chan error, 2)
	for range 2 {
		wg.Add(1)
		go func() { defer wg.Done(); _, e := s.Refresh(a.RefreshToken); errors <- e }()
	}
	wg.Wait()
	close(errors)
	success, rejected := 0, 0
	for e := range errors {
		if e == nil {
			success++
		} else if e == ErrUnauthorized {
			rejected++
		} else {
			t.Fatal(e)
		}
	}
	if success != 1 || rejected != 1 {
		t.Fatalf("success=%d rejected=%d", success, rejected)
	}
	if _, _, e := s.Authenticate(a.AccessToken); e != ErrUnauthorized {
		t.Fatal("replay did not revoke session")
	}
}
func TestAccountsPersistAcrossRestart(t *testing.T) {
	path := filepath.Join(t.TempDir(), "auth.db")
	key := bytes.Repeat([]byte{2}, 32)
	s, e := Open(path, key)
	if e != nil {
		t.Fatal(e)
	}
	s.passwordCost = bcrypt.MinCost
	a := mustRegister(t, s, "a@example.com")
	if e = s.Close(); e != nil {
		t.Fatal(e)
	}
	s, e = Open(path, key)
	if e != nil {
		t.Fatal(e)
	}
	defer s.Close()
	if _, _, e = s.Authenticate(a.AccessToken); e != nil {
		t.Fatal(e)
	}
	if _, e = s.Refresh(a.RefreshToken); e != nil {
		t.Fatal(e)
	}
	if _, e = s.Login("a@example.com", password); e != nil {
		t.Fatal(e)
	}
}
func TestHTTPGuards(t *testing.T) {
	s := serviceForTest(t)
	h := s.Handler([]string{"https://app.example.com"})
	call := func(method, path, body, origin string) *httptest.ResponseRecorder {
		t.Helper()
		r := httptest.NewRequest(method, path, strings.NewReader(body))
		r.Header.Set("Content-Type", "application/json")
		if origin != "" {
			r.Header.Set("Origin", origin)
		}
		w := httptest.NewRecorder()
		h.ServeHTTP(w, r)
		return w
	}
	if w := call("POST", "/v1/auth/register", `{"email":"a@example.com","password":"short"}`, ""); w.Code != 400 {
		t.Fatal(w.Code)
	}
	if w := call("POST", "/v1/auth/register", `{"email":"a@example.com","password":"A-long-test-password","admin":true}`, ""); w.Code != 400 {
		t.Fatal(w.Code)
	}
	if w := call("POST", "/v1/auth/login", `{}`, "https://evil.example"); w.Code != 403 {
		t.Fatal(w.Code)
	}
	w := call("POST", "/v1/auth/register", `{"email":"a@example.com","password":"A-long-test-password"}`, "https://app.example.com")
	if w.Code != 200 {
		t.Fatal(w.Code, w.Body.String())
	}
	var tokens Tokens
	if e := json.Unmarshal(w.Body.Bytes(), &tokens); e != nil {
		t.Fatal(e)
	}
	if w.Header().Get("Cache-Control") != "no-store" {
		t.Fatal("auth response can be cached")
	}
	r := httptest.NewRequest("GET", "/v1/me", nil)
	r.Header.Set("Authorization", "Bearer "+tokens.AccessToken)
	out := httptest.NewRecorder()
	h.ServeHTTP(out, r)
	if out.Code != 200 {
		t.Fatal(out.Code)
	}
	if w := call("GET", "/v1/me", "", ""); w.Code != http.StatusUnauthorized {
		t.Fatal(w.Code)
	}
	for range 35 {
		w = call("POST", "/v1/auth/login", `{}`, "")
	}
	if w.Code != 429 {
		t.Fatal("rate limiting not applied")
	}
}
func TestPruneExpiredPreservesAccount(t *testing.T) {
	s := serviceForTest(t)
	now := time.Now()
	s.now = func() time.Time { return now }
	a := mustRegister(t, s, "a@example.com")
	now = now.Add(sessionLifetime + time.Hour)
	if e := s.PruneExpired(); e != nil {
		t.Fatal(e)
	}
	if e := s.db.View(func(tx *bolt.Tx) error {
		for _, name := range [][]byte{sessionsBucket, refreshBucket} {
			if tx.Bucket(name).Stats().KeyN != 0 {
				t.Fatal("expired records remain")
			}
		}
		return nil
	}); e != nil {
		t.Fatal(e)
	}
	if _, e := s.Login(a.User.Email, password); e != nil {
		t.Fatal("account removed by pruning: ", e)
	}
}
