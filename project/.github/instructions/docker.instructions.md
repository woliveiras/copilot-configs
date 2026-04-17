---
description: "Use when writing, reviewing, or modifying Dockerfile, docker-compose files, or container configuration. Covers Docker security, multi-stage builds, minimal images, and container best practices."
applyTo: "Dockerfile, docker-compose*.yml, .dockerignore"
---

# Docker & Container Infrastructure

## Multi-Stage Build Pattern

Always use multi-stage builds to produce minimal images:

```dockerfile
# Build stage
FROM golang:1.26-alpine AS builder
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /app ./cmd/myapp

# Runtime — scratch for zero attack surface (static Go binaries)
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app /app
EXPOSE 8080
ENTRYPOINT ["/app"]
```

For apps requiring a shell or libc, prefer `distroless` or `alpine` over `debian`/`ubuntu`.

## Image Security

- **Minimal base**: `scratch` for static binaries, `distroless` or `alpine` otherwise
- **CGO_ENABLED=0**: Pure Go binary — no C dependencies, runs on `scratch`
- **CA certificates**: Copy from build stage for HTTPS calls to external services
- **Non-root user**: If not using `scratch`, always run as a non-root user:
  ```dockerfile
  RUN adduser -D -u 1000 app
  USER app
  ```
- **No secrets in images**: Never `COPY` `.env`, credential files, or local data directories
- **Read-only filesystem**: Run with `--read-only`, mount writable paths explicitly
- **Pin versions**: Use specific image tags (`golang:1.26-alpine`), never `latest`
- **Strip binary**: `-ldflags="-s -w"` removes debug symbols (~30% smaller binary)
- **Scan images**: Use `docker scout` or `trivy` in CI

## .dockerignore

Always include `.dockerignore` to speed up builds and prevent leaking sensitive data:

```
.git
node_modules/
dist/
*.db
*.db-wal
*.db-shm
.env
.env.*
```

## Docker Compose (Development)

```yaml
services:
  app:
    build: .
    ports:
      - "8080:8080"
    volumes:
      - ./data:/data
    environment:
      - APP_LOG_LEVEL=debug
    restart: unless-stopped
    read_only: true
    tmpfs:
      - /tmp
    security_opt:
      - no-new-privileges:true
```

## Health Check

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD ["/app", "healthcheck"]
```

Support a `healthcheck` subcommand (or HTTP probe) that exits 0 on healthy, 1 on unhealthy.

## Resource Limits

Document recommended limits:

```yaml
deploy:
  resources:
    limits:
      memory: 256M
      cpus: "1.0"
```

## Logging

- Log to stdout/stderr — Docker captures it via the logging driver
- JSON format in production for structured log parsing
- Never log to files inside the container — use volumes if file logging is needed
- Disable ANSI colors when `NO_COLOR` is set or stdout is not a TTY

## OCI Labels

```dockerfile
ARG VERSION=dev
ARG BUILD_TIME
ARG COMMIT_SHA

LABEL org.opencontainers.image.title="MyApp"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.source="https://github.com/org/repo"
LABEL org.opencontainers.image.created="${BUILD_TIME}"
LABEL org.opencontainers.image.revision="${COMMIT_SHA}"
```

## Cross-Platform Builds

For CGO_ENABLED=0 Go binaries, multi-arch is trivial:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest .
```

## Anti-patterns

- Using `ubuntu`/`debian` as runtime image when a static binary fits in `scratch`
- Running as root inside the container
- `COPY . .` without `.dockerignore` (leaks `.git`, env files, local data)
- Installing debug tools in the runtime image (`curl`, `bash`, `vim`)
- Using `latest` tag for base images — breaks reproducible builds
- Storing application data inside the image layer — always use volumes
- `--privileged` or `--cap-add=ALL` without justification
- Exposing unnecessary ports
