---
description: "Use when writing or reviewing general Python code. Keep this language-level; framework-specific rules belong in separate instruction files."
applyTo: "**/*.py"
---

# Python Conventions

- Type all public function signatures.
- Prefer `str | None` over `Optional[str]` in Python 3.10+ projects.
- Use `from __future__ import annotations` when forward references or older
  supported Python versions require it.
- Use `snake_case` for functions, modules, and variables; use `PascalCase` for
  classes and type names.
- Keep imports grouped: standard library, third-party, local.
- Avoid hidden mutable module state; pass dependencies explicitly.
- Raise specific exceptions or return typed results instead of swallowing
  errors silently.
