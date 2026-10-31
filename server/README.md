# Objectno Go API

Email/password registration, access JWTs, rotating refresh tokens, logout and account deletion. Initial single-process service. It does not yet synchronize journal entries, send verification/recovery email, or implement Telegram login. Not deployed; not a production security certification.

## Run locally

Go 1.27.1 was used for development. From this directory:

```sh
export AUTH_SIGNING_KEY="$(openssl rand -base64 32)"
export AUTH_DB_PATH=private/auth.db
export LISTEN_ADDR=127.0.0.1:8080
# Only if testing from a browser at these origins:
export ALLOWED_ORIGINS=http://localhost:8765,http://127.0.0.1:8765
go run ./cmd/objectno
```

For persistent sessions keep a stable signing key outside Git; regenerating it invalidates existing access JWT signatures. After a compromise revoke affected sessions, rotate the key, and handle refresh tokens as well. Never log the key or tokens. `.env.example` documents configuration; this executable does not automatically load `.env` files.

Place an HTTPS reverse proxy in front of the service for deployment, keep the API loopback-only when proxy and API share a host. Use a non-root service account, a private data directory, restart supervision and backups appropriate to account deletion. bbolt opens a single private database file: one process, not multiple replicas sharing a filesystem. A normal static/PHP hosting plan must not be assumed to support this daemon.

## HTTP contract

All bodies use `application/json`; auth responses are `Cache-Control: no-store`. Successful registration/login/refresh returns `{access_token, refresh_token, expires_in, user: {id, email}}`.

| Method/path | Request | Result |
|---|---|---|
| GET /healthz | — | `{status: "ok"}` |
| POST /v1/auth/register | `{email, password}` | Token pair + user |
| POST /v1/auth/login | `{email, password}` | Token pair + user |
| POST /v1/auth/refresh | `{refresh_token}` | Rotated token pair + user |
| POST /v1/auth/logout | `{refresh_token}` | 204, revokes the whole session |
| GET /v1/me | Authorization: Bearer access_token | `{id, email}` |
| DELETE /v1/me | Bearer access token + `{password}` | 204, deletes account and its server-side sessions/tokens |

Passwords: at least 12 Unicode characters, at most 72 UTF-8 bytes (bcrypt bound). Spaces are not trimmed. Email is trimmed/lowercased. Error bodies are stable codes under `error`: `invalid_input`, `invalid_request`, `invalid_credentials`, `account_exists`, `unauthorized`, `too_many_requests`, `origin_not_allowed`, `json_required`, `server_error`. Clients localize codes, not server messages.

Access JWT: HS256, 15 minutes, required expiry/issuer/audience; user/session existence is checked for each authenticated request. Refresh: 32 random bytes, stored only by SHA-256 hash; absolute session lifetime 30 days. A consumed refresh token cannot be reused; reuse revokes its session, including new tokens. The client must coalesce concurrent refreshes. Lost responses during token rotation may require signing in again; the service intentionally does not silently accept replays.

Server deletion removes account data and session records here. Journals/photos currently live on each client and must also be removed there by the client. This service does not claim to remotely erase offline devices or their backups.

## Abuse controls and limitations

Request bodies are capped at 8 KiB; password hashing concurrency is limited. A bounded in-memory per-peer-IP limit applies. X-Forwarded-For is not trusted; configure appropriate rate limiting at the reverse proxy. Behind a proxy, this service may see all traffic as one peer. Rate-limit state resets on restart; it is not a substitute for production abuse protection. Expired sessions/tokens are pruned on startup and hourly. Email ownership verification and recovery email remain release work.

## Verification

```sh
go test -race ./...
go vet ./...
```

Tests cover signature/algorithm/issuer/audience/expiry, refresh rotation and replay, concurrent refresh, logout, deletion isolation, database persistence, expired-record cleanup, JSON/CORS/rate guards. These do not prove deployment readiness or replace end-to-end device tests.
