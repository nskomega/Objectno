// Package auth implements persisted accounts and revocable, rotating sessions.
package auth

import (
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"net/mail"
	"strings"
	"time"
	"unicode/utf8"

	"github.com/golang-jwt/jwt/v5"
	bolt "go.etcd.io/bbolt"
	"golang.org/x/crypto/bcrypt"
)

var (
	ErrInvalid      = errors.New("invalid input")
	ErrCredentials  = errors.New("invalid credentials")
	ErrUnauthorized = errors.New("session expired or revoked")
	ErrExists       = errors.New("account already exists")
	usersBucket     = []byte("users")
	emailsBucket    = []byte("emails")
	sessionsBucket  = []byte("sessions")
	refreshBucket   = []byte("refresh")
)

const issuer = "objectno"
const audience = "objectno-client"
const accessLifetime = 15 * time.Minute
const sessionLifetime = 30 * 24 * time.Hour

type User struct {
	Guest bool   `json:"guest,omitempty"`
	ID    string `json:"id"`
	Email string `json:"email"`
}
type storedUser struct {
	User
	PasswordHash []byte `json:"password_hash"`
}
type session struct {
	ID      string `json:"id"`
	UserID  string `json:"user_id"`
	Expires int64  `json:"expires"`
	Revoked bool   `json:"revoked"`
}
type refreshRecord struct {
	SessionID string `json:"session_id"`
	UserID    string `json:"user_id"`
	Used      bool   `json:"used"`
	Expires   int64  `json:"expires"`
}
type claims struct {
	SessionID string `json:"sid"`
	jwt.RegisteredClaims
}
type Tokens struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	ExpiresIn    int64  `json:"expires_in"`
	User         User   `json:"user"`
}

type Service struct {
	db           *bolt.DB
	key          []byte
	now          func() time.Time
	passwordCost int
	dummyHash    []byte
}

func Open(path string, key []byte) (*Service, error) {
	if len(key) < 32 {
		return nil, fmt.Errorf("signing key must have at least 32 random bytes")
	}
	db, err := bolt.Open(path, 0600, &bolt.Options{Timeout: time.Second})
	if err != nil {
		return nil, err
	}
	if err = db.Update(func(tx *bolt.Tx) error {
		for _, b := range [][]byte{usersBucket, emailsBucket, sessionsBucket, refreshBucket} {
			if _, e := tx.CreateBucketIfNotExists(b); e != nil {
				return e
			}
		}
		return nil
	}); err != nil {
		db.Close()
		return nil, err
	}
	dummy, err := bcrypt.GenerateFromPassword([]byte("not-a-real-user-password"), 12)
	if err != nil {
		db.Close()
		return nil, err
	}
	return &Service{db: db, key: append([]byte(nil), key...), now: time.Now, passwordCost: 12, dummyHash: dummy}, nil
}
func (s *Service) Close() error { return s.db.Close() }
func randomString() (string, error) {
	b := make([]byte, 32)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(b), nil
}
func hashToken(token string) []byte {
	sum := sha256.Sum256([]byte(token))
	out := make([]byte, hex.EncodedLen(len(sum)))
	hex.Encode(out, sum[:])
	return out
}
func putJSON(b *bolt.Bucket, key string, v any) error {
	raw, err := json.Marshal(v)
	if err != nil {
		return err
	}
	return b.Put([]byte(key), raw)
}
func readJSON(b *bolt.Bucket, key string, v any) error {
	raw := b.Get([]byte(key))
	if raw == nil {
		return ErrUnauthorized
	}
	return json.Unmarshal(raw, v)
}
func normalizeEmail(email string) (string, error) {
	email = strings.ToLower(strings.TrimSpace(email))
	if len(email) > 254 {
		return "", ErrInvalid
	}
	a, err := mail.ParseAddress(email)
	if err != nil || a.Address != email || !strings.Contains(email, "@") {
		return "", ErrInvalid
	}
	return email, nil
}
func validPassword(p string) bool {
	return utf8.ValidString(p) && utf8.RuneCountInString(p) >= 12 && len([]byte(p)) <= 72
}

// Guest issues a normal revocable session without a fabricated email or password.
func (s *Service) Guest() (Tokens, error) {
	id, err := randomString()
	if err != nil {
		return Tokens{}, err
	}
	u := storedUser{User: User{ID: id, Guest: true}}
	var result Tokens
	err = s.db.Update(func(tx *bolt.Tx) error {
		if err := putJSON(tx.Bucket(usersBucket), id, u); err != nil {
			return err
		}
		var err error
		result, err = s.newSession(tx, u.User)
		return err
	})
	return result, err
}

func (s *Service) Register(email, password string) (Tokens, error) {
	email, err := normalizeEmail(email)
	if err != nil || !validPassword(password) {
		return Tokens{}, ErrInvalid
	}
	hash, err := bcrypt.GenerateFromPassword([]byte(password), s.passwordCost)
	if err != nil {
		return Tokens{}, err
	}
	id, err := randomString()
	if err != nil {
		return Tokens{}, err
	}
	u := storedUser{User: User{ID: id, Email: email}, PasswordHash: hash}
	var result Tokens
	err = s.db.Update(func(tx *bolt.Tx) error {
		if tx.Bucket(emailsBucket).Get([]byte(email)) != nil {
			return ErrExists
		}
		if e := putJSON(tx.Bucket(usersBucket), id, u); e != nil {
			return e
		}
		if e := tx.Bucket(emailsBucket).Put([]byte(email), []byte(id)); e != nil {
			return e
		}
		var e error
		result, e = s.newSession(tx, u.User)
		return e
	})
	return result, err
}
func (s *Service) Login(email, password string) (Tokens, error) {
	email, err := normalizeEmail(email)
	if err != nil || len(password) > 72 {
		return Tokens{}, ErrCredentials
	}
	var u storedUser
	err = s.db.View(func(tx *bolt.Tx) error {
		id := tx.Bucket(emailsBucket).Get([]byte(email))
		if id == nil {
			return ErrCredentials
		}
		return readJSON(tx.Bucket(usersBucket), string(id), &u)
	})
	if err != nil {
		_ = bcrypt.CompareHashAndPassword(s.dummyHash, []byte(password))
		return Tokens{}, ErrCredentials
	}
	if bcrypt.CompareHashAndPassword(u.PasswordHash, []byte(password)) != nil {
		return Tokens{}, ErrCredentials
	}
	var result Tokens
	err = s.db.Update(func(tx *bolt.Tx) error {
		// Account can have been deleted while the hash was being checked.
		if tx.Bucket(usersBucket).Get([]byte(u.ID)) == nil {
			return ErrCredentials
		}
		var e error
		result, e = s.newSession(tx, u.User)
		return e
	})
	return result, err
}
func (s *Service) newSession(tx *bolt.Tx, u User) (Tokens, error) {
	id, err := randomString()
	if err != nil {
		return Tokens{}, err
	}
	sess := session{ID: id, UserID: u.ID, Expires: s.now().Add(sessionLifetime).Unix()}
	if err = putJSON(tx.Bucket(sessionsBucket), id, sess); err != nil {
		return Tokens{}, err
	}
	return s.issue(tx, u, sess)
}
func (s *Service) issue(tx *bolt.Tx, u User, sess session) (Tokens, error) {
	refresh, err := randomString()
	if err != nil {
		return Tokens{}, err
	}
	now := s.now()
	expiry := now.Add(accessLifetime)
	if expiry.Unix() > sess.Expires {
		expiry = time.Unix(sess.Expires, 0)
	}
	c := claims{SessionID: sess.ID, RegisteredClaims: jwt.RegisteredClaims{Issuer: issuer, Subject: u.ID, Audience: jwt.ClaimStrings{audience}, IssuedAt: jwt.NewNumericDate(now), ExpiresAt: jwt.NewNumericDate(expiry)}}
	access, err := jwt.NewWithClaims(jwt.SigningMethodHS256, c).SignedString(s.key)
	if err != nil {
		return Tokens{}, err
	}
	record := refreshRecord{SessionID: sess.ID, UserID: u.ID, Expires: sess.Expires}
	if err = putJSON(tx.Bucket(refreshBucket), string(hashToken(refresh)), record); err != nil {
		return Tokens{}, err
	}
	return Tokens{AccessToken: access, RefreshToken: refresh, ExpiresIn: int64(expiry.Sub(now).Seconds()), User: u}, nil
}
func (s *Service) Refresh(token string) (Tokens, error) {
	if len(token) < 32 || len(token) > 256 {
		return Tokens{}, ErrUnauthorized
	}
	var result Tokens
	rejected := false
	err := s.db.Update(func(tx *bolt.Tx) error {
		var record refreshRecord
		if e := readJSON(tx.Bucket(refreshBucket), string(hashToken(token)), &record); e != nil {
			rejected = true
			return nil
		}
		var sess session
		if e := readJSON(tx.Bucket(sessionsBucket), record.SessionID, &sess); e != nil {
			rejected = true
			return nil
		}
		if record.Used {
			sess.Revoked = true
			rejected = true
			return putJSON(tx.Bucket(sessionsBucket), sess.ID, sess)
		}
		if sess.Revoked || sess.Expires <= s.now().Unix() || record.Expires <= s.now().Unix() {
			rejected = true
			return nil
		}
		var u storedUser
		if e := readJSON(tx.Bucket(usersBucket), record.UserID, &u); e != nil {
			rejected = true
			return nil
		}
		record.Used = true
		if e := putJSON(tx.Bucket(refreshBucket), string(hashToken(token)), record); e != nil {
			return e
		}
		var e error
		result, e = s.issue(tx, u.User, sess)
		return e
	})
	if err != nil {
		return Tokens{}, err
	}
	if rejected {
		return Tokens{}, ErrUnauthorized
	}
	return result, nil
}
func (s *Service) Authenticate(token string) (User, string, error) {
	if len(token) > 8192 {
		return User{}, "", ErrUnauthorized
	}
	c := claims{}
	parsed, err := jwt.ParseWithClaims(token, &c, func(_ *jwt.Token) (any, error) { return s.key, nil }, jwt.WithValidMethods([]string{"HS256"}), jwt.WithIssuer(issuer), jwt.WithAudience(audience), jwt.WithExpirationRequired(), jwt.WithIssuedAt(), jwt.WithTimeFunc(s.now))
	if err != nil || !parsed.Valid || c.Subject == "" || c.SessionID == "" {
		return User{}, "", ErrUnauthorized
	}
	var u storedUser
	err = s.db.View(func(tx *bolt.Tx) error {
		var sess session
		if e := readJSON(tx.Bucket(sessionsBucket), c.SessionID, &sess); e != nil {
			return e
		}
		if sess.UserID != c.Subject || sess.Revoked || sess.Expires <= s.now().Unix() {
			return ErrUnauthorized
		}
		return readJSON(tx.Bucket(usersBucket), c.Subject, &u)
	})
	if err != nil {
		return User{}, "", ErrUnauthorized
	}
	return u.User, c.SessionID, nil
}
func (s *Service) Logout(token string) error {
	if len(token) < 32 || len(token) > 256 {
		return ErrUnauthorized
	}
	return s.db.Update(func(tx *bolt.Tx) error {
		var record refreshRecord
		if e := readJSON(tx.Bucket(refreshBucket), string(hashToken(token)), &record); e != nil {
			return e
		}
		var sess session
		if e := readJSON(tx.Bucket(sessionsBucket), record.SessionID, &sess); e != nil {
			return e
		}
		sess.Revoked = true
		return putJSON(tx.Bucket(sessionsBucket), sess.ID, sess)
	})
}
func (s *Service) DeleteAccount(userID, password string) error {
	var u storedUser
	if err := s.db.View(func(tx *bolt.Tx) error { return readJSON(tx.Bucket(usersBucket), userID, &u) }); err != nil {
		return ErrUnauthorized
	}
	if len(password) > 72 || bcrypt.CompareHashAndPassword(u.PasswordHash, []byte(password)) != nil {
		return ErrCredentials
	}
	return s.db.Update(func(tx *bolt.Tx) error {
		for _, name := range [][]byte{sessionsBucket, refreshBucket} {
			b := tx.Bucket(name)
			c := b.Cursor()
			for k, v := c.First(); k != nil; k, v = c.Next() {
				var r struct {
					UserID string `json:"user_id"`
				}
				if e := json.Unmarshal(v, &r); e != nil {
					return e
				}
				if r.UserID == userID {
					if e := c.Delete(); e != nil {
						return e
					}
				}
			}
		}
		if e := tx.Bucket(emailsBucket).Delete([]byte(u.Email)); e != nil {
			return e
		}
		return tx.Bucket(usersBucket).Delete([]byte(userID))
	})
}

// PruneExpired removes expired session/token records; active account data is untouched.
func (s *Service) PruneExpired() error {
	return s.db.Update(func(tx *bolt.Tx) error {
		for _, name := range [][]byte{sessionsBucket, refreshBucket} {
			bucket := tx.Bucket(name)
			cursor := bucket.Cursor()
			for key, value := cursor.First(); key != nil; key, value = cursor.Next() {
				var record struct {
					Expires int64 `json:"expires"`
				}
				if err := json.Unmarshal(value, &record); err != nil {
					return err
				}
				if record.Expires <= s.now().Unix() {
					if err := cursor.Delete(); err != nil {
						return err
					}
				}
			}
		}
		return nil
	})
}
