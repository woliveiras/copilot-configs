---
applyTo: "**"
description: "Security baseline applied to all files. Covers OWASP Top 10 essentials."
---

# Security Baseline

## Input Validation
- Validate all input at system boundaries (HTTP handlers, CLI args, file reads)
- Use allowlists over denylists when possible
- Reject unexpected input early — fail fast

## Injection Prevention
- SQL: always use parameterized queries — never string concatenation
- Shell: avoid `exec`/`system` with user input; use argument arrays
- HTML: escape output in templates

## Authentication & Secrets
- Never hardcode secrets, API keys, or credentials in source code
- Use environment variables or secret managers
- Never log secrets, tokens, or PII

## Dependencies
- Keep dependencies updated
- Prefer well-maintained libraries with security track records
- Pin dependency versions for reproducible builds

## Error Handling
- Do not expose stack traces or internal details to users
- Log errors with context for debugging; return generic messages to callers
- Handle all error paths — no silent failures
