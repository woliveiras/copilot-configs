# AGENTS.md

This file is the operating contract for coding agents in this repository.
Follow it before using generic global defaults.

## Instruction Order

1. Treat the nearest project-local `AGENTS.md` as the active operating contract.
2. Use `.github/copilot-instructions.md` as supporting context when you need
   project overview, commands, or repository conventions.
3. Load `.github/instructions/*.instructions.md` only when their `applyTo`
   patterns match the files being edited.
4. Use `.github/skills/*/SKILL.md` for explicit workflows.
5. Use `.github/agents/*.agent.md` only when a named role is useful.

If a global instruction conflicts with this file, this file wins.

## Core Rules

- Do not change production code before understanding the relevant spec, task,
  bugfix document, or user request.
- Do not modify tests just to make them pass. If a test appears wrong, revisit
  the spec or acceptance criteria first.
- Do not create ADRs for routine or easy-to-reverse choices.
- Do not create `CONSTITUTION.md` by default. Use this file for operational
  rules unless the user explicitly asks for a separate constitution.
- Do not commit, amend, or push without explicit user confirmation.
- Preserve user changes. Never revert unrelated work.

## Domain Vocabulary

Read `GLOSSARY.md` or `CONTEXT.md` before writing PRDs, specs, tests, reviews,
bugfix documents, ADRs, or user-facing copy.

For new projects, prefer `GLOSSARY.md`. If the repository already uses
`CONTEXT.md`, preserve that convention. If both exist, read both and treat
`GLOSSARY.md` as canonical terminology and `CONTEXT.md` as broader domain
context unless the project says otherwise. If they conflict, ask before editing
either file.

Absence of both files does not block work.

## Artifact Locations

Use these paths unless the project already documents a different convention:

| Artifact | Default path |
| --- | --- |
| PRD | `docs/prds/YYYY-MM-DD-<feature-slug>.md` |
| Spec | `specs/YYYY-MM-DD-<feature-slug>.md` |
| Feature folder | `specs/YYYY-MM-DD-<feature-slug>/` |
| Feature plan | `specs/YYYY-MM-DD-<feature-slug>/plan.md` |
| Feature tasks | `specs/YYYY-MM-DD-<feature-slug>/tasks.md` |
| Repo-level tasks | `tasks.md` |
| Bugfix document | `docs/bugfixes/YYYY-MM-DD-<bug-slug>.md` |
| Postmortem | `docs/postmortems/YYYY-MM-DD-<incident-slug>.md` |
| ADR | `docs/decisions/NNNN-title-with-dashes.md` |

Use the local date when creating timestamped files. Slugs are lowercase
kebab-case and should describe the user-visible capability or symptom.

## Workflows

### New Features

1. Use `requirements-interview` to explore code and clarify requirements.
2. Write or update a PRD when the product behavior needs framing.
3. Use `generate-spec` or `spec-writer` to create a testable spec.
4. Use `task-breakdown` to create vertical tasks.
5. Use `vertical-tdd` to implement one behavior at a time.
6. Use `reviewer` for spec-driven review.
7. Use `update-docs` when API, architecture, setup, or configuration changed.
8. Use `git-commit` only after verification and explicit confirmation.

### Existing Features

1. Decide whether the product flow changes.
2. If the product flow changes, update the PRD first.
3. If the product flow does not change, write targeted specs.
4. Continue through tasks, tests, implementation, review, and docs.

### Bugs

1. Use `bugfix-loop`.
2. Save the bugfix document under `docs/bugfixes/`.
3. Build a reproduction loop before changing production code.
4. Add or update a regression test at the correct boundary.
5. Apply the fix and rerun the original reproduction.
6. Write a postmortem only when the bug was an outage.

## Skill Routing

Use these skills instead of reimplementing their procedures inline:

- `requirements-interview`: clarify product and technical requirements.
- `generate-spec`: write a structured spec from known requirements.
- `task-breakdown`: create vertical implementation tasks.
- `generate-tests-from-spec`: generate tests from acceptance criteria.
- `vertical-tdd`: implement one behavior per red-green-refactor cycle.
- `bugfix-loop`: investigate and fix bugs with reproduction and regression.
- `generate-glossary`: create or update domain vocabulary.
- `generate-adr`: record durable architecture decisions.
- `update-docs`: sync documentation after implementation.
- `session-handoff`: prepare another session or agent to continue.
- `git-commit`: inspect staged changes and create a commit with confirmation.

## Agent Routing

- Use `spec-writer` when requirements are unclear and a spec is needed.
- Use `reviewer` for spec-driven review.
- Use `architect` for architecture exploration with multiple design options.
- Use `explorer` for read-only project mapping.

## Verification

Before saying work is complete:

- Run the focused tests for the changed behavior.
- Run the nearest relevant suite when practical.
- Report any verification that could not be run.
- Check that temporary logs, harnesses, and instrumentation were removed.
- Check `git status --short` and explain remaining changes.
