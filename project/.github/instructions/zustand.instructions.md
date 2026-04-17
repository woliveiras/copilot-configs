---
description: "Use when creating, editing, or reviewing Zustand v5 stores. Covers store structure, middleware ordering, immer mutations, persistence, and selector patterns."
applyTo: "**/store/**/*.ts, **/stores/**/*.ts"
---

# Zustand v5 Conventions

## When to use

- **Shared UI state** multiple components need to read: auth credentials, theme, preferences
- State that survives component unmounts but is not server state

Do NOT use Zustand for:
- Server state → TanStack Query
- Local component state → `useState`/`useReducer`
- URL state → router search params

## Store structure

Split state and actions into separate interfaces:

```ts
interface MyState {
  value: string
  count: number
}

interface MyActions {
  setValue: (v: string) => void
  increment: () => void
  reset: () => void
}

export const useMyStore = create<MyState & MyActions>()(/* middleware */)
```

## Middleware

### With persistence
```ts
create<State & Actions>()(
  devtools(
    persist(
      immer((set) => ({ /* state + actions */ })),
      {
        name: "app-<store-name>",              // unique localStorage key
        partialize: (state) => ({ key: state.key }), // persist only what's needed
      },
    ),
    { name: "<StoreName>Store", enabled: import.meta.env.DEV },
  ),
)
```

### Without persistence
```ts
create<State & Actions>()(
  devtools(
    immer((set) => ({ /* state + actions */ })),
    { name: "<StoreName>Store", enabled: import.meta.env.DEV },
  ),
)
```

**Middleware order:** `devtools` outermost → `persist` → `immer` innermost.

## Immer mutations

With `immer` middleware, mutate the draft directly in actions:

```ts
updateItem: (id, changes) =>
  set((state) => {
    const item = state.items.find((i) => i.id === id)
    if (item) Object.assign(item, changes)
  }),
```

To replace the whole state (e.g. `reset`), return a new object:

```ts
reset: () => set(() => ({ ...DEFAULT_STATE })),
```

## Persistence

- Use `partialize` — never persist derived state or functions
- If the data already has its own persistence mechanism (e.g. `localStorage.setItem`
  called manually), do NOT also use Zustand `persist` — it would duplicate writes
- Keys must be unique per store: use `"appname-<store-name>"` format

## Syncing with XState

XState owns logic (transitions, guards, side effects).
Zustand is the read cache for components.
Sync in a Provider via subscription, not inside the machine:

```ts
useEffect(() => {
  const sub = actorRef.subscribe((snapshot) => {
    if (snapshot.matches("authenticated")) {
      setAuth(snapshot.context.user, snapshot.context.token)
    } else if (snapshot.matches("unauthenticated")) {
      clearAuth()
    }
  })
  return () => sub.unsubscribe()
}, [actorRef])
```

## Selectors

Select the minimum slice to avoid unnecessary re-renders:

```ts
// ✅ Granular
const isAuthenticated = useAuthStore((s) => s.isAuthenticated)

// ✅ Object selector (Zustand v5 uses shallow comparison by default)
const { theme, fontSize } = useSettingsStore((s) => ({ theme: s.theme, fontSize: s.fontSize }))

// ❌ Whole store — re-renders on any state change
const store = useAuthStore()
```

Export only the hook (`useMyStore`), not the store object itself.
