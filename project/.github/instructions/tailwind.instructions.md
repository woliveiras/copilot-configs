---
description: "Use when writing, reviewing, or refactoring Tailwind CSS utility classes. Covers Tailwind v4 syntax, CSS-first configuration, theme variables, breaking changes from v3, and patterns to avoid common linter/build errors."
applyTo: "**/*.tsx, **/*.ts, **/*.css"
---

# Tailwind CSS v4 — Conventions and Patterns

Tailwind CSS v4 is a ground-up rewrite. Many patterns from v3 are invalid or deprecated.

## Setup

```css
/* index.css */
@import "tailwindcss";   /* single import — no @tailwind directives */

@theme {
  /* design tokens go here */
}
```

```ts
// vite.config.ts
import tailwindcss from "@tailwindcss/vite"
export default defineConfig({ plugins: [tailwindcss()] })
```

- **No `tailwind.config.js`** — configuration lives in CSS via `@theme`
- **No `content` array** — Tailwind auto-detects source files
- **No `postcss-import` or `autoprefixer`** — handled automatically

## CSS-First Configuration (`@theme`)

All design tokens are defined in CSS:

```css
@import "tailwindcss";

@theme {
  --color-brand: oklch(0.72 0.11 221);
  --font-display: "Inter", sans-serif;
  --breakpoint-3xl: 120rem;
}
```

- `--color-*` creates utilities: `bg-brand`, `text-brand`, `border-brand`
- `--font-*` creates: `font-display`
- `--breakpoint-*` creates responsive variants: `3xl:*`
- Use `@theme` for tokens that should generate utilities
- Use `:root` for CSS variables that should NOT generate utilities

## ⚠️ Breaking Changes from v3

### 1. Import syntax
```css
/* ❌ v3 */
@tailwind base;
@tailwind components;
@tailwind utilities;

/* ✅ v4 */
@import "tailwindcss";
```

### 2. Renamed utilities
| v3 | v4 |
|---|---|
| `shadow-sm` | `shadow-xs` |
| `shadow` | `shadow-sm` |
| `blur-sm` | `blur-xs` |
| `blur` | `blur-sm` |
| `rounded-sm` | `rounded-xs` |
| `rounded` | `rounded-sm` |

### 3. Removed deprecated utilities
```css
/* ❌ Removed */
bg-opacity-50     → bg-black/50
text-opacity-50   → text-black/50
flex-shrink-0     → shrink-0
flex-grow         → grow
```

### 4. `outline-none` → `outline-hidden`
```html
<!-- ✅ v4: accessible outline hiding -->
<input class="focus:outline-hidden" />
<!-- outline-none now literally sets outline-style: none (skips forced-colors mode) -->
```

### 5. Default `ring` width: 3px → 1px
```html
<!-- ✅ v4: be explicit -->
<button class="focus:ring-3 focus:ring-blue-500" />
```

### 6. Default border color: `gray-200` → `currentColor`
```html
<!-- ✅ Always specify border color -->
<div class="border border-gray-200">
```

### 7. CSS variable arbitrary values
```html
<!-- ✅ v4 syntax -->
<div class="bg-(--brand-color)">
```

### 8. `!important` modifier moved to the end
```html
<!-- ✅ v4 -->
<div class="flex! bg-red-500!">
```

### 9. Variant stacking: right-to-left → left-to-right
```html
<!-- ✅ v4 (reads like CSS selector) -->
<ul class="*:first:pt-0 *:last:pb-0">
```

## Custom Utilities

```css
/* ✅ v4 — use @utility */
@utility tab-4 {
  tab-size: 4;
}

/* ✅ base styles still use @layer base */
@layer base {
  h1 { font-size: var(--text-2xl); }
}
```

## Dynamic Class Names

Tailwind scans files as plain text — class names must be complete strings:

```tsx
// ❌ Tailwind will NOT detect these
<div className={`text-${color}-600`} />

// ✅ Use a lookup map with complete class names
const colorMap = { red: "text-red-600", blue: "text-blue-600" }
<div className={colorMap[color]} />
```

## `hover:` now requires pointer device

v4 wraps `hover:` in `@media (hover: hover)` automatically — touch devices won't trigger
hover on tap. If you need the old behavior:

```css
@custom-variant hover (&:hover);
```
