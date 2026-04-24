---
description: "Use when writing, reviewing, or modifying Dockerfile, docker-compose files, or container configuration."
applyTo: "**/Dockerfile, **/docker-compose*.yml, **/.dockerignore"
---

# Docker & Container Infrastructure

## Required Patterns

- Always use **multi-stage builds** — separate build and runtime stages
- Minimal base images: `scratch` for static binaries, `distroless` or `alpine` otherwise
- **Non-root user**: always `USER app` (except `scratch`)
- **Pin versions**: specific image tags, never `latest`
- Always include `.dockerignore` (exclude `.git`, `.env`, `node_modules/`, `*.db*`)
- **No secrets in images**: never `COPY` `.env` or credential files
- Strip binaries: `-ldflags="-s -w"` for Go
- Read-only filesystem with `--read-only`, mount writable paths explicitly

## Health Check

Support a `healthcheck` subcommand or HTTP probe:

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD ["/app", "healthcheck"]
```

## Compose Security Defaults

```yaml
read_only: true
tmpfs: [/tmp]
security_opt: [no-new-privileges:true]
```

## OCI Labels

Always include: `image.title`, `image.version`, `image.source`, `image.created`, `image.revision`.

## Logging

- Log to stdout/stderr — never to files inside the container
- JSON format in production
- Respect `NO_COLOR` env var

## Anti-patterns

- `ubuntu`/`debian` as runtime when `scratch` works
- Running as root
- `COPY . .` without `.dockerignore`
- `latest` tag for base images
- `--privileged` or `--cap-add=ALL` without justification
