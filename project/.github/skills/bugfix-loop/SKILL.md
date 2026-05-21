---
name: bugfix-loop
description: "Run a disciplined bugfix loop with reproduction, hypotheses, regression test, fix, and cleanup. Use when: fixing bugs, debugging regressions, investigating failures, or deciding whether an outage needs a postmortem."
---

# Bugfix Loop

Fix bugs by building evidence before changing code.

## Document Location

Save bugfix documents under:

```text
docs/bugfixes/YYYY-MM-DD-<bug-slug>.md
```

Use the local date when the investigation starts. The slug must be lowercase
kebab-case, based on the user-visible symptom or failing capability, for example:

```text
docs/bugfixes/2026-05-21-login-redirect-loop.md
```

If a relevant bugfix document already exists, update it instead of creating a
duplicate. If the bug has an issue, ticket, or PR reference, put that reference
inside the document, not in the filename.

For outages, save the postmortem separately under:

```text
docs/postmortems/YYYY-MM-DD-<incident-slug>.md
```

## Process

1. Create or update a bugfix document with:
   - symptom
   - impact
   - reproduction steps
   - expected behavior
   - actual behavior
   - outage status
2. Build a reproduction loop before changing production code. Prefer a failing
   test, then an HTTP/CLI/browser script, then a small harness.
3. Confirm the loop reproduces the user's bug, not a nearby failure.
4. Write 3-5 ranked hypotheses. Each hypothesis must predict what evidence
   would confirm or falsify it.
5. Instrument only the boundary needed to test the current hypothesis. Tag any
   temporary logs clearly so they can be removed.
6. Convert the minimized reproduction into a regression test at the correct
   seam.
7. Apply the fix, then rerun the regression test and the original reproduction
   loop.
8. Remove temporary instrumentation and record the actual cause.
9. If the bug was an outage, write a postmortem. If it was not an outage, stop
   at the bugfix document and regression test.

## Bugfix Document Template

```markdown
# Bugfix: <user-visible symptom>

**Status:** investigating | fixed | won't fix
**Date opened:** YYYY-MM-DD
**Source:** issue/PR/user report/log link, or "local report"
**Outage:** yes | no

## Summary

One or two sentences describing the broken behavior and the expected behavior.

## Impact

- Who or what is affected
- Scope/frequency
- User-visible consequence

## Reproduction

**Environment:** local/staging/production, relevant versions, flags, or config

**Steps:**
1. ...
2. ...
3. ...

**Expected:** ...

**Actual:** ...

**Reproduction command or loop:**

```bash
<command that reproduces or verifies the bug>
```

## Hypotheses

| Rank | Hypothesis | Prediction | Result |
| --- | --- | --- | --- |
| 1 | ... | If this is true, then ... | pending |

## Investigation Log

- YYYY-MM-DD HH:MM: observation, command, or evidence

## Regression Test

- Test file:
- Test name:
- Failure observed before fix: yes | no

## Fix

- Root cause:
- Code change:
- Why this fixes the root cause:

## Verification

- [ ] Regression test passes
- [ ] Original reproduction no longer reproduces
- [ ] Related test suite passes
- [ ] Temporary instrumentation removed

## Follow-ups

- [ ] Follow-up task, if needed
```

## Rules

- Do not guess a fix before reproduction unless the user explicitly accepts the
  risk.
- Do not create a postmortem for every bug.
- Create `docs/bugfixes/` and `docs/postmortems/` lazily, only when the first
  document of each type is needed.
- If no correct regression seam exists, document that as an architecture finding.
- Use `GLOSSARY.md` or `CONTEXT.md` vocabulary when either exists.
