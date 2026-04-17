---
description: "Use when creating, editing, or reviewing XState v5 state machines. Covers createMachine vs setup(), onDone/onError event typing, actor patterns, and testing with createActor."
applyTo: "**/*.machine.ts, **/*.machine.test.ts"
---

# XState v5 Conventions

## When to use

Use XState for features with **multiple exclusive states and side effects**:
- Auth flows: `checkingSession → authenticating → authenticated / unauthenticated`
- Multi-step wizards, async resource lifecycles (`idle → loading → ready / failed`)
- Anything with guarded transitions, parallel states, or complex event handling

For simple toggles or preferences, use Zustand instead.

## `createMachine` vs `setup().createMachine()`

**Use `createMachine(config, implementations)` when the machine has `onDone`/`onError`.**

`setup().createMachine()` has a known issue: actions in `setup.actions` receive the event
typed as your union — `DoneActorEvent` is not in that union, so `event.output` is
inaccessible at runtime.

**❌ Avoid for machines with `invoke`/`onDone`/`onError`:**
```ts
export const myMachine = setup({
  actions: {
    setResult: assign({ data: ({ event }) => event.output }), // undefined at runtime
  },
}).createMachine({ ... })
```

**✅ Use `createMachine` with inline `assign` and `unknown` cast:**
```ts
export const myMachine = createMachine(
  {
    states: {
      loading: {
        invoke: {
          src: "fetchData",
          onDone: {
            target: "ready",
            actions: assign(({ event }: { event: unknown }) => {
              const e = event as { output: MyResult }
              return { data: e.output, error: null }
            }),
          },
          onError: {
            target: "failed",
            actions: assign(({ event }: { event: unknown }) => {
              const e = event as { error: unknown }
              return { error: e.error instanceof Error ? e.error.message : "Unknown error" }
            }),
          },
        },
      },
    },
  },
  { actors: { fetchData: fetchDataActor } },
)
```

`setup().createMachine()` is fine for pure event-driven machines with no `invoke`.

## Types

Declare `types` at the top of the machine config for full TypeScript inference:

```ts
export const myMachine = createMachine({
  types: {
    context: {} as MyContext,
    events: {} as MyEvent,
  },
  // ...
})
```

## Actors

- `fromPromise` — async operations (API calls, async init)
- `fromCallback` — event-based / DOM listeners
- Pass runtime dependencies via `input`, never close over mutable state:

```ts
invoke: {
  src: "myActor",
  input: ({ context }) => context,
}
```

## Consuming in React

```ts
import { useActorRef, useSelector } from "@xstate/react"

// Provider — creates actor once
const actorRef = useActorRef(myMachine)

// Consumer — subscribe to minimum slice (avoids unnecessary re-renders)
const isLoading = useSelector(actorRef, (s) => s.matches("loading"))
const error = useSelector(actorRef, (s) => s.context.error)

actorRef.send({ type: "RETRY" })
```

Expose `actorRef` via React context so consumers don't recreate the machine.

## Testing with `createActor`

```ts
const actor = createActor(myMachine)
actor.start()
actor.send({ type: "SUBMIT" })
expect(actor.getSnapshot().value).toBe("submitting")
actor.stop()
```

Override actors in tests with `machine.provide()`:

```ts
const actor = createActor(
  myMachine.provide({
    actors: { fetchData: fromPromise(async () => mockResult) },
  }),
)
```

### Async assertions — avoid polling on state name

`vi.waitFor(() => snapshot.matches("X"))` can miss transient states.

**✅ Wait for observable side effects, then check context:**
```ts
await vi.waitFor(() => expect(mockFn).toHaveBeenCalled())
await vi.waitFor(() => actor.getSnapshot().context.data !== null)
```

Always call `actor.stop()` after each test.
