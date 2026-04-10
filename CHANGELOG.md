# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

This changelog is automatically maintained by [release-please](https://github.com/googleapis/release-please).

## [1.1.0](https://github.com/woliveiras/copilot-configs/compare/v1.0.0...v1.1.0) (2026-04-10)


### Features

* update CI and release workflows to ignore specific paths on push ([79dff1e](https://github.com/woliveiras/copilot-configs/commit/79dff1e0a5a697cd708ab3beb9299e7c7f9fae32))

## 1.0.0 (2026-04-10)


### Features

* add .gitignore file to exclude OS and editor-specific files ([60141ca](https://github.com/woliveiras/copilot-configs/commit/60141ca3fe48485986b3cc17d5c901fc429025c3))
* add architecture improvement, code explorer, and code reviewer agents ([bc1cbf8](https://github.com/woliveiras/copilot-configs/commit/bc1cbf888dbf56a9daac88cbfaab3c075f4406c3))
* add bug report template to facilitate issue reporting and improve troubleshooting ([f9b8df3](https://github.com/woliveiras/copilot-configs/commit/f9b8df3d94da9091e47d8250bf5588573ede57ad))
* add CI workflow for shell script linting and installation testing ([5ad0e92](https://github.com/woliveiras/copilot-configs/commit/5ad0e928598309c49012135dd4aa653ab6fc6404))
* add CONTRIBUTING.md to guide contributions and improve project quality ([b03c415](https://github.com/woliveiras/copilot-configs/commit/b03c4154f8e60c8b77ec573569f79118dfd5257f))
* add Contributor Covenant Code of Conduct to promote a respectful community ([d77bb51](https://github.com/woliveiras/copilot-configs/commit/d77bb513f32621e448ee4ffde4b4a09feee25caf))
* add documentation and templates for glossary, spec generation, and unit testing ([2a362c6](https://github.com/woliveiras/copilot-configs/commit/2a362c62939c1dc031068c13ef27aa3ed9d3afa7))
* add feature request template to streamline suggestions and enhance clarity ([18eb98c](https://github.com/woliveiras/copilot-configs/commit/18eb98cd7c2edb7892b0405e21a3b3bce007027e))
* add guardrails for command safety and implement blocking script ([e5cfd50](https://github.com/woliveiras/copilot-configs/commit/e5cfd509e5ed1aba8dc0f5b7a9fae0c03cfcf150))
* add guidelines for various programming languages including Go, Python, TypeScript, Kotlin, React, and security best practices ([0b1ce70](https://github.com/woliveiras/copilot-configs/commit/0b1ce701ab980a37a9210f0679fa6ad174b5ce75))
* add initial release configuration and changelog for project ([e0bef0e](https://github.com/woliveiras/copilot-configs/commit/e0bef0e17d5fe2be64499c1f06243473913b508c))
* add installer and uninstaller scripts for copilot-configs ([c8ff593](https://github.com/woliveiras/copilot-configs/commit/c8ff593968ff8472f1eba9b34e273eb57629f7bd))
* add mise.toml configuration file for tool version management ([fd1fdeb](https://github.com/woliveiras/copilot-configs/commit/fd1fdebb9be782a78a1fe7d40943bd39b199e713))
* add MIT License to the project for legal clarity and usage rights ([925513e](https://github.com/woliveiras/copilot-configs/commit/925513e8a4a9b403f505b7c4fab07f728e44f251))
* add pull request template to standardize contributions and improve clarity ([a37057d](https://github.com/woliveiras/copilot-configs/commit/a37057dc461fc2857bb00744a009a66f9559f74e))
* add reference documents for complexity signals, deep modules, dependency categories, interface design, pragmatic heuristics, and seam finding ([c32dbec](https://github.com/woliveiras/copilot-configs/commit/c32dbec9507566d2ae4bebc8eeb018ac28e2b402))
* add spec writer agent for structured feature specifications ([664664c](https://github.com/woliveiras/copilot-configs/commit/664664cc24da25321181dd82b2ba2f2bcbec5faf))
* add structured prompts for code refactoring, review, and testing ([3d28698](https://github.com/woliveiras/copilot-configs/commit/3d2869874a5aeef558327d60678d3adf60f7efba))
* enhance CI workflow with simulated global install and improve command parsing in hook script ([50989fa](https://github.com/woliveiras/copilot-configs/commit/50989fae492fe3d09b836be6ce4c3ae38e9847b2))

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
