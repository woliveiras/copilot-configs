---
description: "Code review with a structured checklist. Use when you want a thorough review of code changes."
---

Review the provided code changes using this checklist:

## Correctness
- Does the code do what it claims to do?
- Are edge cases handled?
- Are error paths covered?

## Tests
- Are there tests for the new/changed behavior?
- Do tests cover edge cases and error scenarios?
- Are test names descriptive enough to serve as documentation?

## Security
- Is user input validated and sanitized?
- Are queries parameterized (no string concatenation)?
- Are secrets kept out of code?

## Readability
- Is the code clear without excessive comments?
- Are names descriptive and consistent with the codebase?
- Are functions focused (single responsibility)?

## Architecture
- Does this change respect the existing module boundaries?
- Are dependencies flowing in the right direction?
- Could this be simplified without losing functionality?

Be specific. Point to exact lines. Suggest concrete alternatives, not vague improvements.
