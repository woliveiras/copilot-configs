---
description: "Use when writing, reviewing, or refactoring Tailwind CSS v4 utility classes in components. Covers breaking changes from v3, renamed utilities, and patterns to avoid."
applyTo: "**/components/**/*.tsx, **/features/**/*.tsx, **/pages/**/*.tsx"
---

# Tailwind CSS v4 — Breaking Changes and Patterns

## Renamed Utilities (v3 → v4)

| v3 | v4 |
|---|---|
| `shadow-sm` | `shadow-xs` |
| `shadow` | `shadow-sm` |
| `blur-sm` | `blur-xs` |
| `blur` | `blur-sm` |
| `rounded-sm` | `rounded-xs` |
| `rounded` | `rounded-sm` |

## Removed Deprecated Utilities

```
bg-opacity-50     → bg-black/50
text-opacity-50   → text-black/50
flex-shrink-0     → shrink-0
flex-grow         → grow
```

## Changed Defaults

- `outline-none` → `outline-hidden` (accessible outline hiding)
- `ring` width: 3px → 1px — be explicit: `focus:ring-3`
- Border color: `gray-200` → `currentColor` — always specify: `border border-gray-200`

## v4 Syntax

- CSS variable arbitrary values: `bg-(--brand-color)`
- `!important` modifier at the end: `flex!`, `bg-red-500!`
- Variant stacking is now left-to-right: `*:first:pt-0 *:last:pb-0`
- `hover:` wraps in `@media (hover: hover)` — touch devices won't trigger hover on tap

## Dynamic Class Names

Class names must be complete strings — Tailwind scans files as plain text:

```tsx
// ❌ Tailwind will NOT detect these
<div className={`text-${color}-600`} />

// ✅ Use a lookup map with complete class names
const colorMap = { red: "text-red-600", blue: "text-blue-600" }
<div className={colorMap[color]} />
```
