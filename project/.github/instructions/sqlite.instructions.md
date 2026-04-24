---
description: "SQLite conventions with WAL mode, goose migrations, and Go patterns."
applyTo: "**/*.sql, **/database/**/*.go, **/migrations/**"
---

# SQLite Best Practices

## Driver: modernc.org/sqlite (pure Go, zero CGo)

## Connection — Required Pragmas

```go
dsn := "file:app.db?_journal_mode=WAL&_busy_timeout=5000&_foreign_keys=ON&_synchronous=NORMAL"
db.SetMaxOpenConns(1) // SQLite: one writer at a time
```

- `_journal_mode=WAL` — concurrent reads while writing
- `_busy_timeout=5000` — wait on lock instead of immediate SQLITE_BUSY
- `_foreign_keys=ON` — off by default, must enable explicitly
- `SetMaxOpenConns(1)` — prevents write contention

## Always Parameterized Queries

Never concatenate strings into SQL. Always `?` placeholders.

## Schema Conventions

- Primary keys: `INTEGER PRIMARY KEY AUTOINCREMENT`
- Timestamps: `TEXT` in ISO 8601
- Booleans: `INTEGER` (0/1) with `NOT NULL DEFAULT 0`
- Always define indexes for columns in WHERE, JOIN, ORDER BY
- Foreign keys: always `ON DELETE CASCADE` or `ON DELETE SET NULL`

## Migrations (goose)

- SQL-based in `migrations/`, named `001_initial_schema.sql`
- Each file has `-- +goose Up` and `-- +goose Down`
- Never modify an applied migration — create a new one
- Run on app startup

## Testing

In-memory database for unit tests: `file::memory:?cache=shared&_foreign_keys=ON`

## Anti-patterns

- `SetMaxOpenConns > 1` — causes SQLITE_BUSY
- Missing `_foreign_keys=ON` — constraints silently ignored
- Missing `_busy_timeout` — immediate errors under load
- String concatenation in queries
- Not backing up WAL/SHM files alongside the main DB
