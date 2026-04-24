---
description: "Go code quality based on Effective Go and Uber Go Style Guide."
applyTo: "**/*.go"
---

# Go Code Quality

Follow [Effective Go](https://go.dev/doc/effective_go) and [Uber Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md).

## Naming (project-specific)

- Package names: lowercase, single word, no plural (`book` not `books`)
- No `Get` prefix on getters: `book.Title()` not `book.GetTitle()`
- Error variables: `ErrNotFound` (exported), `errNotFound` (unexported)
- Error types: suffix `Error` (`NotFoundError`)

## Error Handling

- Wrap errors with context: `fmt.Errorf("find book %d: %w", id, err)`
- Handle errors once: either log OR return, never both
- Use `%w` for errors callers match, `%v` to obfuscate
- Error messages: lowercase, no "failed to" prefix
- Sentinel errors for `errors.Is`, custom types for `errors.As`

## Interfaces

- Accept interfaces, return structs
- Define interfaces at the consumer side, not the implementation
- Verify compliance: `var _ http.Handler = (*MyHandler)(nil)`

## Concurrency

- Every goroutine must have a shutdown mechanism (`context.Context` or `done` channel)
- Never fire-and-forget goroutines
- Channel size: 0 or 1. Larger buffers need justification

## Functions

- `run()` pattern: `func main() { if err := run(); err != nil { log.Fatal(err) } }`
- `os.Exit` / `log.Fatal` only in `main()`

## Testing

- Table-driven tests with `testify`, `give`/`want` field prefixes
- `t.Parallel()` where safe
- Don't mock what you don't own — wrap behind interfaces
- Fuzzing for parser/input handling functions

## Linting

Run `golangci-lint` with: `errcheck`, `govet`, `staticcheck`, `revive`, `goimports`, `gosec`.

## Anti-patterns

- `init()` functions (except driver registration)
- Mutable global variables
- Named returns (except short functions or `defer` error handling)
- `panic` in library code
