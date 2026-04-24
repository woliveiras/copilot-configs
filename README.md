# copilot-configs

[![CI](https://github.com/woliveiras/copilot-configs/actions/workflows/ci.yml/badge.svg)](https://github.com/woliveiras/copilot-configs/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![ShellCheck](https://img.shields.io/badge/shell-ShellCheck-brightgreen)](https://www.shellcheck.net/)

**Dotfiles for AI** — opinionated GitHub Copilot configurations for VS Code. Agents, skills, instructions, hooks, and prompts. One command to install.

## Why?

Every project needs the same Copilot setup: language-specific instructions, code review prompts, testing conventions, security guardrails. Instead of copying files between repos, install once and apply everywhere.

**What you get:**

- **8 instruction files** covering Go, TypeScript, Python, Kotlin, React, Astro/MDX, testing, and security
- **4 agents** for spec-driven development: write specs → generate tests → implement code → update docs
- **11 skills** with templates for specs, tests, docs, migrations, ADRs, state management patterns, and conventional commits
- **Command guardrails** that block `git push --force`, `rm -rf /`, `terraform destroy`, and other dangerous commands
- **4 global prompts** for code review, refactoring, test generation, and SDD workflow

```
copilot-configs/
├── install.sh / uninstall.sh          # Install scripts
├── user/prompts/                      # Global prompts (review, refactor, test)
└── project/
    ├── mise.toml                      # Tool version management template
    └── .github/
        ├── copilot-instructions.md    # Project-level Copilot instructions
        ├── instructions/              # 9 language & convention files
        ├── agents/                    # 4 agents + 6 design references
        │   └── references/            # Deep modules, interface design, etc.
        ├── skills/                    # 11 skills with asset templates
        └── hooks/                     # Command guardrails (BLOCK/ASK rules)
```

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/woliveiras/copilot-configs/main/install.sh | bash
```

This clones the repo to `~/.copilot-configs/` and copies global prompts to your VS Code user directory.

## Project Setup

After installing, apply project-level configs to any repository:

```bash
~/.copilot-configs/install.sh --project
```

To also configure `copilot-instructions.md` placeholders interactively:

```bash
~/.copilot-configs/install.sh --project --configure
```

The `--configure` flag offers two modes:
- **Interactive** — answer questions about your project
- **Auto-detect** — detects stack, directories and build commands from manifest files

You can also run `--configure` standalone on an existing project to reconfigure:

```bash
~/.copilot-configs/install.sh --configure
```

Run from inside your project directory. Existing files are preserved by default. Use `--force` to overwrite.

## What's Included

### Global (user-level)

Installed to `~/Library/Application Support/Code/User/prompts/` (macOS) or `~/.config/Code/User/prompts/` (Linux).

| File | Purpose |
|------|---------|
| `review.prompt.md` | Structured code review checklist |
| `refactor.prompt.md` | Refactor preserving behavior |
| `test.prompt.md` | Generate unit tests matching project patterns |
| `sdd.prompt.md` | Full SDD cycle: spec → test → implement → review → docs |

### Project-level

Installed to `.github/` in your project root.

#### Instructions (`.github/instructions/`)

| File | Applies To | Focus |
|------|-----------|-------|
| `typescript.instructions.md` | `**/*.ts, **/*.tsx` | Strict mode, interfaces, named exports |
| `go.instructions.md` | `**/*.go` | Error wrapping, table-driven tests, context |
| `python.instructions.md` | `**/*.py` | Type hints 3.12+, uv, pytest, structlog |
| `kotlin.instructions.md` | `**/*.kt` | MVVM, Hilt, Room, Compose |
| `react.instructions.md` | `**/*.tsx, **/*.jsx` | TanStack Query, feature-sliced, a11y |
| `astro-mdx.instructions.md` | `**/*.mdx, **/*.astro` | Frontmatter, no H1, code fences |
| `testing.instructions.md` | `**/*.test.*, **/*.spec.*` | AAA pattern, self-contained tests |
| `security.instructions.md` | `**` | OWASP baseline, no hardcoded secrets |

#### Agents (`.github/agents/`)

| Agent | Role |
|-------|------|
| `spec-writer` | Interviews you to produce a structured spec. Detects large scope and breaks into vertical slices. |
| `explorer` | Read-only codebase mapper. Produces a structured project summary. |
| `reviewer` | Reviews code against specs and tests as source of truth. |
| `architect` | Multi-design evaluation: explores → candidates → 3 parallel sub-designs → recommends. Saves RFC or ADR. |

Agents reference design heuristics in `.github/agents/references/` (deep modules, interface design, complexity signals, dependency categories, pragmatic heuristics, seam finding).

#### When to Use What: Code Review

There are three review surfaces — each for a different context:

| Surface | How to invoke | Best for |
|---------|--------------|----------|
| `@reviewer` agent | `@reviewer review this change` | **Spec-driven review** — verifies code against specs and tests, checks architecture with deep-module heuristics. Use when specs exist. |
| `/review` prompt | Type `/review` in Copilot Chat | **Quick general review** — security, readability, correctness checklist. Use for fast feedback on any code, no specs needed. |
| Built-in `/review` | `/review` in Copilot CLI | **Diff-based review** — analyzes staged/branch changes automatically. Use for pre-commit or pre-PR checks. |

#### Skills (`.github/skills/`)

| Skill | Purpose |
|-------|---------|
| `spec-template` | Fill a structured spec from direct input (no interview) |
| `test-from-spec` | Generate unit tests from a spec's acceptance criteria |
| `doc-updater` | Update `docs/` after implementing a feature |
| `conventional-commit` | Write commit messages in Conventional Commits format |
| `glossary` | Extract domain terminology into `GLOSSARY.md` |
| `rfc-template` | Generate a structured RFC for architecture decisions |
| `adr-template` | Record an Architectural Decision in MADR 4.0 format |
| `zod-patterns` | Zod validation recipes (API clients, forms, localStorage) |
| `react-router-migration` | Step-by-step guide for React Router v6 → v7 migration |
| `xstate-patterns` | XState v5 recipes: React integration, actors, testing |
| `zustand-patterns` | Zustand v5 recipes: middleware setup, immer, XState sync |

#### Hooks (`.github/hooks/`)

Command guardrails that intercept dangerous terminal commands:

- **BLOCK**: `git push --force`, `rm -rf /`, `terraform destroy`, secret leaks
- **ASK**: `git push`, `sudo`, `DROP TABLE`, `pip install`, `npm install -g`

Rules are configurable in `guardrails-rules.txt`.

### mise.toml

Template for [mise](https://mise.jdx.dev/) tool version management. Uncomment the tools your project uses.

## Spec Driven Development (SDD) Workflow

This project is built around **Spec Driven Development** — specs and tests are the source of truth, code adapts to them.

### The Cycle

```
┌─────────┐     ┌──────────┐     ┌────────────┐     ┌──────────┐     ┌──────┐
│  1.Spec │────▶│ 2.Tests  │────▶│ 3.Implement│────▶│ 4.Review │────▶│5.Docs│
└─────────┘     └──────────┘     └────────────┘     └──────────┘     └──────┘
 @spec-writer    test-from-spec   Write code        @reviewer        doc-updater
 or              skill            to pass tests     agent            skill
 spec-template                    (never edit                        (if API/arch
 skill                            tests)                             changed)
```

### Quick Start — `/sdd` Prompt

The fastest way to run the full cycle is the `/sdd` global prompt. In Copilot Chat:

```
/sdd Add user authentication with JWT
```

The prompt orchestrates each step in order with explicit gates — it won't advance without your approval.

### Step by Step (Manual)

You can also run each step individually:

#### 1. Write a Spec

```
@spec-writer I need a feature for user authentication with JWT
```

The agent interviews you (one question at a time), then produces a structured spec in `specs/`. For large features, it auto-detects scope and proposes vertical slices.

If you already know the requirements and don't need an interview:

```
Use the spec-template skill to create a spec for JWT auth
```

#### 2. Generate Tests

```
Use the test-from-spec skill for specs/user-auth.md
```

Each acceptance criterion from the spec becomes at least one test. Tests must fail initially (red phase).

#### 3. Implement

Write code to make the tests pass. The golden rule: **never modify the tests**. If a test seems wrong, revisit the spec first.

#### 4. Review

```
@reviewer review the user-auth implementation
```

The reviewer checks alignment between spec → tests → code. It verifies every acceptance criterion has a test, every test has matching code, and flags architecture issues using deep-module heuristics.

For quick reviews without specs, use the `/review` prompt instead.

#### 5. Update Docs

```
Use the doc-updater skill for the user-auth feature
```

Only needed when public API, architecture, or setup changed. Skip for internal-only changes.

### Architecture Decisions

When the feature involves significant design choices, use these before or alongside the SDD cycle:

| Need | Tool | Output |
|------|------|--------|
| Explore architecture opportunities | `@architect` agent | RFC or ADR with 3 evaluated designs |
| Record a quick decision | `adr-template` skill | ADR in `docs/decisions/` (MADR 4.0) |
| Propose a change for review | `rfc-template` skill | RFC in `docs/rfcs/` |

## Customization

All files are meant to be edited. After running `--project`:

1. **Edit `copilot-instructions.md`** — fill in project name, description, directory structure, and build commands
2. **Remove unused instruction files** — drop languages you don't use
3. **Tune guardrails** — add or remove rules in `guardrails-rules.txt`
4. **Uncomment mise tools** — configure versions in `mise.toml`

## Uninstall

```bash
~/.copilot-configs/uninstall.sh
```

Removes global configs. Project-level files are not touched.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.

## License

MIT
