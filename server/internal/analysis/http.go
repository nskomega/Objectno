package analysis

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"image"
	_ "image/jpeg"
	_ "image/png"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"
)

type Input struct {
	Photo      string   `json:"photo"`
	Wish       string   `json:"wish"`
	Language   string   `json:"language"`
	WorkScopes []string `json:"work_scopes"`
}
type Proposal struct {
	SceneMatches  bool     `json:"scene_matches"`
	Observations  []string `json:"observations"`
	Concept       string   `json:"concept"`
	WorkSteps     []string `json:"work_steps"`
	Materials     []string `json:"materials"`
	Questions     []string `json:"questions"`
	Uncertainties []string `json:"uncertainties"`
}
type Result struct {
	Proposal      Proposal `json:"proposal"`
	WorkScopes    []string `json:"work_scopes"`
	Model         string   `json:"model"`
	Revision      string   `json:"revision"`
	PromptVersion int      `json:"prompt_version"`
	ElapsedMS     int64    `json:"elapsed_ms"`
	PeakMemoryGB  float64  `json:"peak_memory_gb"`
}

func NewHandler(authenticate func(string) error, workerURL string, origins []string) http.Handler {
	endpoint, err := url.Parse(workerURL)
	if err != nil || endpoint.Scheme != "http" || (endpoint.Hostname() != "127.0.0.1" && endpoint.Hostname() != "localhost" && endpoint.Hostname() != "::1") || endpoint.User != nil || endpoint.RawQuery != "" {
		workerURL = ""
	}
	client := &http.Client{Timeout: 150 * time.Second, Transport: &http.Transport{Proxy: nil}, CheckRedirect: func(_ *http.Request, _ []*http.Request) error { return http.ErrUseLastResponse }}
	slot := make(chan struct{}, 1)
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Cache-Control", "no-store")
		w.Header().Set("X-Content-Type-Options", "nosniff")
		origin := r.Header.Get("Origin")
		if origin != "" {
			allowed := false
			for _, v := range origins {
				if v != "" && v == origin {
					allowed = true
				}
			}
			if !allowed {
				fail(w, 403, "origin_not_allowed")
				return
			}
			w.Header().Set("Access-Control-Allow-Origin", origin)
			w.Header().Set("Vary", "Origin")
			w.Header().Set("Access-Control-Allow-Headers", "Authorization, Content-Type")
			w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
		}
		if r.Method == http.MethodOptions {
			w.WriteHeader(204)
			return
		}
		if r.Method != http.MethodPost {
			w.Header().Set("Allow", "POST, OPTIONS")
			fail(w, 405, "method_not_allowed")
			return
		}
		header := r.Header.Get("Authorization")
		if !strings.HasPrefix(header, "Bearer ") || authenticate(strings.TrimPrefix(header, "Bearer ")) != nil {
			fail(w, 401, "unauthorized")
			return
		}
		if workerURL == "" {
			fail(w, 503, "unavailable")
			return
		}
		if !strings.HasPrefix(r.Header.Get("Content-Type"), "application/json") {
			fail(w, 415, "json_required")
			return
		}
		r.Body = http.MaxBytesReader(w, r.Body, 12*1024*1024)
		var input Input
		decoder := json.NewDecoder(r.Body)
		decoder.DisallowUnknownFields()
		if decoder.Decode(&input) != nil || decoder.Decode(new(any)) != io.EOF || !validInput(input) {
			fail(w, 400, "invalid_input")
			return
		}
		select {
		case slot <- struct{}{}:
			defer func() { <-slot }()
		default:
			fail(w, 429, "busy")
			return
		}
		data, _ := json.Marshal(input)
		ctx, cancel := context.WithTimeout(r.Context(), 150*time.Second)
		defer cancel()
		request, err := http.NewRequestWithContext(ctx, http.MethodPost, workerURL, bytes.NewReader(data))
		if err != nil {
			fail(w, 503, "unavailable")
			return
		}
		request.Header.Set("Content-Type", "application/json")
		response, err := client.Do(request)
		if err != nil {
			fail(w, 503, "unavailable")
			return
		}
		defer response.Body.Close()
		if response.StatusCode == 429 {
			fail(w, 429, "busy")
			return
		}
		if response.StatusCode != 200 {
			fail(w, 502, "analysis_failed")
			return
		}
		body, err := io.ReadAll(io.LimitReader(response.Body, 65537))
		if err != nil || len(body) > 65536 {
			fail(w, 502, "analysis_failed")
			return
		}
		var result Result
		d := json.NewDecoder(bytes.NewReader(body))
		d.DisallowUnknownFields()
		if d.Decode(&result) != nil || d.Decode(new(any)) != io.EOF || !validResult(result) || !sameScopes(input.WorkScopes, result.WorkScopes) {
			fail(w, 502, "analysis_failed")
			return
		}
		// Revalidate the active session after expensive inference before returning data.
		if authenticate(strings.TrimPrefix(header, "Bearer ")) != nil {
			fail(w, 401, "unauthorized")
			return
		}
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(result)
	})
}
func validScopes(scopes []string) bool {
	if len(scopes) < 1 || len(scopes) > 4 {
		return false
	}
	seen := map[string]bool{}
	for _, scope := range scopes {
		if seen[scope] || !map[string]bool{"wall_paint": true, "floor_finish": true, "lighting": true, "textiles": true}[scope] {
			return false
		}
		seen[scope] = true
	}
	return true
}
func sameScopes(input, output []string) bool {
	if !validScopes(output) || len(input) != len(output) {
		return false
	}
	wanted := map[string]bool{}
	for _, scope := range input {
		wanted[scope] = true
	}
	for _, scope := range output {
		if !wanted[scope] {
			return false
		}
	}
	return true
}
func validInput(v Input) bool {
	if !validScopes(v.WorkScopes) {
		return false
	}

	if len(v.Photo) > 11200000 || len(strings.TrimSpace(v.Wish)) == 0 || len(v.Wish) > 8000 {
		return false
	}
	if !map[string]bool{"ru": true, "en": true, "es": true, "fr": true, "de": true, "it": true, "pt": true, "tr": true}[v.Language] {
		return false
	}
	data, err := base64.StdEncoding.Strict().DecodeString(v.Photo)
	if err != nil || len(data) > 8*1024*1024 {
		return false
	}
	config, format, err := image.DecodeConfig(bytes.NewReader(data))
	return err == nil && (format == "jpeg" || format == "png") && config.Width > 0 && config.Height > 0 && int64(config.Width)*int64(config.Height) <= 16000000
}
func validResult(v Result) bool {
	if v.Model == "" || v.Revision == "" || v.PromptVersion < 1 || len(v.Proposal.Concept) > 4800 {
		return false
	}
	if len(v.Proposal.Observations) < 1 || len(v.Proposal.Observations) > 6 || len(v.Proposal.WorkSteps) > 7 || len(v.Proposal.Materials) > 8 || len(v.Proposal.Questions) > 6 || len(v.Proposal.Uncertainties) > 6 {
		return false
	}
	if !v.Proposal.SceneMatches && (len(v.Proposal.WorkSteps) > 0 || len(v.Proposal.Materials) > 0) {
		return false
	}
	for _, list := range [][]string{v.Proposal.Observations, v.Proposal.WorkSteps, v.Proposal.Materials, v.Proposal.Questions, v.Proposal.Uncertainties, {v.Proposal.Concept}} {
		for _, text := range list {
			if len(text) > 4800 || strings.Contains(strings.ToLower(text), "http://") || strings.Contains(strings.ToLower(text), "https://") {
				return false
			}
		}
	}
	return true
}
func fail(w http.ResponseWriter, status int, code string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(map[string]string{"error": code})
}
