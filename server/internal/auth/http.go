package auth

import (
	"encoding/json"
	"errors"
	"io"
	"net"
	"net/http"
	"strings"
	"sync"
	"time"
)

type window struct {
	count int
	until time.Time
}
type limiter struct {
	mu      sync.Mutex
	windows map[string]window
}

func (l *limiter) allow(key string) bool {
	l.mu.Lock()
	defer l.mu.Unlock()
	now := time.Now()
	if len(l.windows) > 10000 {
		for k, w := range l.windows {
			if now.After(w.until) {
				delete(l.windows, k)
			}
		}
		if len(l.windows) > 10000 {
			return false
		}
	}
	w := l.windows[key]
	if now.After(w.until) {
		w = window{until: now.Add(time.Minute)}
	}
	w.count++
	l.windows[key] = w
	return w.count <= 30
}

// Handler does not trust X-Forwarded-For. A reverse proxy must also limit requests.
func (s *Service) Handler(allowedOrigins []string) http.Handler {
	mux := http.NewServeMux()
	limits := &limiter{windows: map[string]window{}}
	workers := make(chan struct{}, 4)
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, r *http.Request) { reply(w, 200, map[string]string{"status": "ok"}) })
	for path, fn := range map[string]func(string, string) (Tokens, error){"/v1/auth/register": s.Register, "/v1/auth/login": s.Login} {
		mux.HandleFunc("POST "+path, func(w http.ResponseWriter, r *http.Request) {
			var body struct {
				Email    string `json:"email"`
				Password string `json:"password"`
			}
			if !decode(w, r, &body) {
				return
			}
			select {
			case workers <- struct{}{}:
				defer func() { <-workers }()
			default:
				reply(w, 429, map[string]string{"error": "too_many_requests"})
				return
			}
			tokens, err := fn(body.Email, body.Password)
			if err != nil {
				replyError(w, err)
				return
			}
			reply(w, 200, tokens)
		})
	}
	mux.HandleFunc("POST /v1/auth/refresh", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			Token string `json:"refresh_token"`
		}
		if !decode(w, r, &body) {
			return
		}
		tokens, err := s.Refresh(body.Token)
		if err != nil {
			replyError(w, err)
			return
		}
		reply(w, 200, tokens)
	})
	mux.HandleFunc("POST /v1/auth/logout", func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			Token string `json:"refresh_token"`
		}
		if !decode(w, r, &body) {
			return
		}
		if err := s.Logout(body.Token); err != nil {
			replyError(w, err)
			return
		}
		w.WriteHeader(http.StatusNoContent)
	})
	mux.HandleFunc("GET /v1/me", func(w http.ResponseWriter, r *http.Request) {
		u, _, err := s.Authenticate(bearer(r))
		if err != nil {
			replyError(w, err)
			return
		}
		reply(w, 200, u)
	})
	mux.HandleFunc("DELETE /v1/me", func(w http.ResponseWriter, r *http.Request) {
		u, _, err := s.Authenticate(bearer(r))
		if err != nil {
			replyError(w, err)
			return
		}
		var body struct {
			Password string `json:"password"`
		}
		if !decode(w, r, &body) {
			return
		}
		select {
		case workers <- struct{}{}:
			defer func() { <-workers }()
		default:
			reply(w, 429, map[string]string{"error": "too_many_requests"})
			return
		}
		if err = s.DeleteAccount(u.ID, body.Password); err != nil {
			replyError(w, err)
			return
		}
		w.WriteHeader(http.StatusNoContent)
	})
	origins := map[string]bool{}
	for _, o := range allowedOrigins {
		if o != "" {
			origins[o] = true
		}
	}
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Cache-Control", "no-store")
		w.Header().Set("X-Content-Type-Options", "nosniff")
		if origin := r.Header.Get("Origin"); origin != "" {
			if !origins[origin] {
				reply(w, 403, map[string]string{"error": "origin_not_allowed"})
				return
			}
			w.Header().Set("Access-Control-Allow-Origin", origin)
			w.Header().Set("Vary", "Origin")
			w.Header().Set("Access-Control-Allow-Headers", "Authorization, Content-Type")
			w.Header().Set("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS")
		}
		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		ip, _, err := net.SplitHostPort(r.RemoteAddr)
		if err != nil {
			ip = r.RemoteAddr
		}
		if r.URL.Path != "/healthz" && !limits.allow(ip) {
			w.Header().Set("Retry-After", "60")
			reply(w, 429, map[string]string{"error": "too_many_requests"})
			return
		}
		mux.ServeHTTP(w, r)
	})
}
func bearer(r *http.Request) string {
	v := r.Header.Get("Authorization")
	if !strings.HasPrefix(v, "Bearer ") {
		return ""
	}
	return strings.TrimPrefix(v, "Bearer ")
}
func decode(w http.ResponseWriter, r *http.Request, v any) bool {
	if !strings.HasPrefix(strings.ToLower(r.Header.Get("Content-Type")), "application/json") {
		reply(w, 415, map[string]string{"error": "json_required"})
		return false
	}
	r.Body = http.MaxBytesReader(w, r.Body, 8192)
	d := json.NewDecoder(r.Body)
	d.DisallowUnknownFields()
	if d.Decode(v) != nil || d.Decode(&struct{}{}) != io.EOF {
		reply(w, 400, map[string]string{"error": "invalid_request"})
		return false
	}
	return true
}
func reply(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(v)
}
func replyError(w http.ResponseWriter, err error) {
	switch {
	case errors.Is(err, ErrInvalid):
		reply(w, 400, map[string]string{"error": "invalid_input"})
	case errors.Is(err, ErrExists):
		reply(w, 409, map[string]string{"error": "account_exists"})
	case errors.Is(err, ErrCredentials):
		reply(w, 401, map[string]string{"error": "invalid_credentials"})
	case errors.Is(err, ErrUnauthorized):
		reply(w, 401, map[string]string{"error": "unauthorized"})
	default:
		reply(w, 500, map[string]string{"error": "server_error"})
	}
}
