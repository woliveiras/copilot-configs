---
description: "Use when writing or reviewing Android Kotlin code, mobile storage, permissions, networking, or authentication flows."
applyTo: "**/*.kt, **/AndroidManifest.xml"
---

# Android Security Conventions

- Do not store secrets, tokens, or credentials in plain SharedPreferences,
  resources, or source code.
- Prefer Android Keystore-backed storage for sensitive local secrets.
- Request the minimum permissions needed; explain any dangerous permission.
- Validate deep links and intent extras before using them.
- Do not log tokens, credentials, PII, or full server responses.
- Use HTTPS endpoints and avoid disabling certificate validation.
- Keep authentication state changes explicit and testable.
