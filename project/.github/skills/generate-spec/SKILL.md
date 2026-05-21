---
name: generate-spec
description: "Generate a structured spec from direct input. Use when: you already know what you want and just need the formatted template. For exploration and interviews, use the spec-writer agent instead."
---

# Generate Spec

Generate a structured feature specification using the template below.
Use this when you already know the requirements and just need them formatted.

## When to Use

- You have a clear idea of what to build
- You want a formatted spec without an interview
- You're documenting an existing decision

For unclear requirements that need exploration, use the `spec-writer` agent instead.

## File Location and Naming

Default location:

```text
specs/YYYY-MM-DD-<feature-slug>.md
```

Use the local date when the spec is created. Use lowercase kebab-case for
`<feature-slug>`, based on the user-visible capability, for example:

```text
specs/2026-05-21-jwt-authentication.md
specs/2026-05-21-invoice-export.md
```

If the feature already has a folder with multiple artifacts, save the spec as:

```text
specs/YYYY-MM-DD-<feature-slug>/spec.md
```

Use the folder form only when the feature also needs related artifacts such as
`plan.md`, `tasks.md`, research notes, or multiple specs. Do not create a folder
just to hold a single spec.

If a relevant spec already exists, update it instead of creating a duplicate.
Do not add a second timestamp when updating an existing spec.

## Procedure

1. Ask the user for the feature name, brief description, and whether this is a
   new feature, feature expansion, or documentation of an existing decision.
2. Check for an existing matching spec in `specs/`.
3. Choose the file path using the rules above.
4. Fill in the [spec template](./assets/spec-template.md).
5. Save the completed spec to the chosen path.

## Output

Use the template from [assets/spec-template.md](./assets/spec-template.md).
Ensure every acceptance criterion is testable (maps to at least one unit test).

## Rules

- Do not leave placeholder text in the saved spec.
- Keep acceptance criteria in Given/When/Then form when possible.
- Use `GLOSSARY.md` or `CONTEXT.md` vocabulary when either exists.
- Put implementation sequencing in `plan.md` or `tasks.md`, not in the spec.
- Put accepted architectural decisions in an ADR, not only in the spec.
