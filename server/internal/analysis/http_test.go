package analysis

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"errors"
	"image"
	"image/color"
	"image/png"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync/atomic"
	"testing"
)

func photo() string {
	var b bytes.Buffer
	m := image.NewRGBA(image.Rect(0, 0, 2, 2))
	m.Set(0, 0, color.White)
	_ = png.Encode(&b, m)
	return base64.StdEncoding.EncodeToString(b.Bytes())
}
func inputBody() string {
	b, _ := json.Marshal(Input{Photo: photo(), Wish: "Refresh room", Language: "ru"})
	return string(b)
}
func sample() Result {
	return Result{Proposal: Proposal{SceneMatches: true, Observations: []string{"Visible wall"}, Concept: "A lighter finish", WorkSteps: []string{"Confirm scope"}, Materials: []string{"Paint"}, Questions: []string{"Dimensions?"}, Uncertainties: []string{"Hidden services unknown"}}, Model: "test-model", Revision: "test-revision", PromptVersion: 1}
}
func call(h http.Handler, body, token string) *httptest.ResponseRecorder {
	r := httptest.NewRequest("POST", "/v1/analysis", strings.NewReader(body))
	r.Header.Set("Content-Type", "application/json")
	if token != "" {
		r.Header.Set("Authorization", "Bearer "+token)
	}
	w := httptest.NewRecorder()
	h.ServeHTTP(w, r)
	return w
}
func TestAuthBoundsAndNoFakeOutput(t *testing.T) {
	var calls atomic.Int32
	worker := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		calls.Add(1)
		var v Input
		if json.NewDecoder(r.Body).Decode(&v) != nil || v.Wish != "Refresh room" {
			t.Error("request not forwarded correctly")
		}
		_ = json.NewEncoder(w).Encode(sample())
	}))
	defer worker.Close()
	auth := func(s string) error {
		if s != "valid" {
			return errors.New("revoked")
		}
		return nil
	}
	h := NewHandler(auth, worker.URL, nil)
	if w := call(h, inputBody(), ""); w.Code != 401 {
		t.Fatal(w.Code)
	}
	if calls.Load() != 0 {
		t.Fatal("unauthenticated request reached model")
	}
	for _, body := range []string{`{"photo":"broken","wish":"x","language":"ru"}`, `{"photo":"","wish":"","language":"ru"}`, inputBody() + ` {}`, strings.Replace(inputBody(), `"ru"`, `"xx"`, 1)} {
		if w := call(h, body, "valid"); w.Code != 400 {
			t.Fatal(w.Code, w.Body.String())
		}
	}
	if calls.Load() != 0 {
		t.Fatal("invalid input reached model")
	}
	w := call(h, inputBody(), "valid")
	if w.Code != 200 || !strings.Contains(w.Body.String(), "test-model") {
		t.Fatal(w.Code, w.Body.String())
	}
	if w.Header().Get("Cache-Control") != "no-store" {
		t.Fatal("result may be cached")
	}
}
func TestRevocationDuringInference(t *testing.T) {
	var active atomic.Bool
	active.Store(true)
	worker := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		active.Store(false)
		_ = json.NewEncoder(w).Encode(sample())
	}))
	defer worker.Close()
	h := NewHandler(func(string) error {
		if active.Load() {
			return nil
		}
		return errors.New("revoked")
	}, worker.URL, nil)
	if w := call(h, inputBody(), "valid"); w.Code != 401 {
		t.Fatal(w.Code)
	}
}
func TestMalformedOrRemoteOutputFailsClosed(t *testing.T) {
	for _, body := range []string{`{}`, strings.Repeat("x", 65537), `{"proposal":{}}`} {
		worker := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) { _, _ = w.Write([]byte(body)) }))
		h := NewHandler(func(string) error { return nil }, worker.URL, nil)
		if w := call(h, inputBody(), "valid"); w.Code != 502 {
			t.Fatal(w.Code)
		}
		worker.Close()
	}
	h := NewHandler(func(string) error { return nil }, "https://example.com/analyze", nil)
	if w := call(h, inputBody(), "valid"); w.Code != 503 {
		t.Fatal("remote worker must be disabled", w.Code)
	}
}
func TestOnlyOneModelRequestAndExplicitOrigins(t *testing.T) {
	entered, release := make(chan struct{}), make(chan struct{})
	worker := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		close(entered)
		<-release
		_ = json.NewEncoder(w).Encode(sample())
	}))
	defer worker.Close()
	h := NewHandler(func(string) error { return nil }, worker.URL, []string{"http://localhost:8767"})
	done := make(chan *httptest.ResponseRecorder, 1)
	go func() { done <- call(h, inputBody(), "valid") }()
	<-entered
	if w := call(h, inputBody(), "valid"); w.Code != 429 {
		t.Error(w.Code)
	}
	close(release)
	if w := <-done; w.Code != 200 {
		t.Error(w.Code)
	}
	r := httptest.NewRequest("OPTIONS", "/v1/analysis", nil)
	r.Header.Set("Origin", "http://evil.example")
	w := httptest.NewRecorder()
	h.ServeHTTP(w, r)
	if w.Code != 403 {
		t.Fatal(w.Code)
	}
	r.Header.Set("Origin", "http://localhost:8767")
	w = httptest.NewRecorder()
	h.ServeHTTP(w, r)
	if w.Code != 204 {
		t.Fatal(w.Code)
	}
}
