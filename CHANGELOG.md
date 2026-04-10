# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

This changelog is automatically maintained by [release-please](https://github.com/googleapis/release-please).

## [0.1.0](https://github.com/woliveiras/copilot-configs/releases/tag/v0.1.0) — 2026-04-10

### Features

- Install script (`install.sh`) with OS detection (macOS/Linux), `--project` and `--force` flags
- Uninstall script (`uninstall.sh`) for global config removal
- 3 global user prompts: review, refactor, test
- Project template with `copilot-instructions.md` (Spec Driven Development workflow)
- 9 instruction files: TypeScript, Go, Python, Kotlin, React, Astro/MDX, testing, security, conventional commits
- 4 agents: spec-writer, explorer, reviewer, architect
- 6 agent references: deep modules, interface design, complexity signals, dependency categories, pragmatic heuristics, seam finding
- 4 skills: spec-template, test-from-spec, doc-updater, glossary
- Command guardrails (hooks) with configurable BLOCK/ASK rules
- mise.toml template for tool version management
- GitHub Actions CI: ShellCheck, structure validation, install tests (Ubuntu + macOS)
- Contributing guide, Code of Conduct, issue and PR templates
