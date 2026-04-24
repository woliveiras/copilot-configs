---
description: "Use when writing or reviewing TanStack Query v5 hooks, queries, or mutations. Covers single-object API, removed callbacks, Suspense, and breaking changes from v4."
applyTo: "**/hooks/**/*.ts, **/hooks/**/*.tsx, **/api/**/*.ts, **/queries/**/*.ts"
---

# TanStack Query v5 Conventions

## Single Options Object — Always

```ts
// ✅ v5
useQuery({ queryKey: ["books"], queryFn: fetchBooks })
useMutation({ mutationFn: createBook })

// ❌ v4 overloads (removed)
useQuery(["books"], fetchBooks)
useMutation(createBook)
```

All hooks AND `queryClient` methods use a single options object.

## Removed: onSuccess, onError, onSettled from useQuery

```ts
// ❌ v4 — removed in v5
useQuery({ queryKey: ["user"], queryFn: fetchUser, onSuccess: (data) => setUser(data) })

// ✅ v5 — use status flags in the component
const { data, isSuccess, isError, error } = useQuery({ queryKey: ["user"], queryFn: fetchUser })

useEffect(() => {
  if (isSuccess) setUser(data)
}, [isSuccess, data])
```

Note: `onSuccess`/`onError`/`onSettled` are still available on `useMutation`.

## Renamed Properties

| v4 | v5 |
|---|---|
| `cacheTime` | `gcTime` |
| `keepPreviousData` | Use `placeholderData: keepPreviousData` (import from tanstack) |
| `isLoading` (first load) | `isPending` (no data yet) + `isFetching` (any fetch) |
| `isInitialLoading` | `isLoading` (isPending + isFetching) |

## Suspense — First Class

```ts
// ✅ v5 — dedicated Suspense hooks (data is always defined)
const { data } = useSuspenseQuery({ queryKey: ["books"], queryFn: fetchBooks })
```

Use `useSuspenseQuery`, `useSuspenseInfiniteQuery`, `useSuspenseQueries` instead of the `suspense: true` option.

## Custom Hooks Pattern

Always wrap queries in custom hooks — never call `useQuery` directly in components:

```ts
export function useBooks() {
  return useQuery({
    queryKey: ["books"],
    queryFn: fetchBooks,
  })
}

export function useCreateBook() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: createBook,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["books"] }),
  })
}
```

## Query Keys

- Use arrays with descriptive segments: `["books", bookId, "reviews"]`
- Query key factories for consistency:

```ts
export const bookKeys = {
  all: ["books"] as const,
  detail: (id: string) => ["books", id] as const,
  reviews: (id: string) => ["books", id, "reviews"] as const,
}
```

## Invalidation

- Invalidate after mutations: `queryClient.invalidateQueries({ queryKey: ["books"] })`
- Uses prefix matching by default — `["books"]` invalidates `["books", "1"]` too
