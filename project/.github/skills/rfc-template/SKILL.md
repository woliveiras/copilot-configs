---
name: rfc-template
description: "Generate a structured RFC from direct input. Use when: writing an RFC, architecture decision, design doc, proposing a change. For full architecture analysis, use the architect agent instead."
---

# RFC Template

Generate a structured Request for Comments (RFC) document using the template below.
Use this when you already know the problem and proposed solution.

## When to Use

- You have a clear architectural change to propose
- You want a formatted RFC without a full architecture analysis
- You're documenting an existing design decision

For complex architecture exploration with module-deepening analysis,
use the `architect` agent instead.

## Procedure

1. Ask the user for the topic and a brief description of the problem
2. Fill in the template below
3. Save to `docs/rfcs/<topic>.md`

## Template

```markdown
# RFC: <Title>

## Problem
[What's wrong and why it matters]

## Proposal
[The recommended design or change]

## Alternatives Considered
[Other approaches and why they were rejected]

## Migration Plan
[How to get from here to there incrementally]

## Test Impact
[What tests change, what new boundary tests are needed]
```

## Rules

- Keep the Problem section focused — one paragraph, not a history lesson
- Proposal must be concrete enough to implement from
- Always include at least 2 alternatives (even if one is "do nothing")
- Migration plan should be incremental — no big-bang rewrites
