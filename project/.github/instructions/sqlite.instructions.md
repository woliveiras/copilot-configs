---
description: "Use when writing SQL queries, designing schema, working with SQLite, creating migrations, or optimizing queries. Covers WAL mode, parameterized queries, goose migrations, and performance patterns."
applyTo: "**/*.sql, **/database/**/*.go, **/migrations/**"
---

# SQLite Best Practices

## Driver (Go): modernc.org/sqlite

- Pure Go, zero CGo — cross-compiles to any platform without a C toolchain
- Import as `_ "modernc.org/sqlite"` and use via `database/sql`

## Connection Setup

```go
func OpenDB(path string) (*sql.DB, error) {
    dsn := fmt.Sprintf(
        "file:%s?_journal_mode=WAL&_busy_timeout=5000&_foreign_keys=ON&_synchronous=NORMAL",
        path,
    )
    db, err := sql.Open("sqlite", dsn)
    if err != nil {
        return nil, fmt.Errorf("open database: %w", err)
    }
    // SQLite performs best with a single writer connection
    db.SetMaxOpenConns(1)
    return db, nil
}
```

Critical pragmas:
- `_journal_mode=WAL` — Write-Ahead Logging for concurrent reads
- `_busy_timeout=5000` — Wait up to 5s on lock instead of immediate SQLITE_BUSY
- `_foreign_keys=ON` — Enforce FK constraints (off by default!)
- `_synchronous=NORMAL` — Good balance of safety and performance with WAL

## WAL Mode

- Allows concurrent reads while writing — essential for web applications
- **ONE writer at a time** — `SetMaxOpenConns(1)` prevents write contention
- Readers never block writers; writers never block readers
- Back up all three files together: `*.db`, `*.db-wal`, `*.db-shm`

## Parameterized Queries — Always

```go
// ✅ Parameterized
row := db.QueryRowContext(ctx, "SELECT title FROM books WHERE id = ?", id)

// ❌ Never — SQL injection
db.Query("SELECT * FROM books WHERE id = " + id)
db.Query(fmt.Sprintf("SELECT * FROM books WHERE title = '%s'", title))
```

## Schema Conventions

- Primary keys: `INTEGER PRIMARY KEY AUTOINCREMENT`
- Timestamps: `TEXT` in ISO 8601 (`strftime('%Y-%m-%dT%H:%M:%SZ', 'now')`)
- Booleans: `INTEGER` (0/1) with `NOT NULL DEFAULT 0`
- JSON fields: `TEXT` with `DEFAULT '{}'`
- Always define indexes for columns used in WHERE, JOIN, ORDER BY
- Foreign keys: always define with `ON DELETE CASCADE` or `ON DELETE SET NULL`

## Migrations (goose)

- SQL-based migrations in a `migrations/` directory
- Naming: `001_initial_schema.sql`, `002_add_users.sql`
- Each file has `-- +goose Up` and `-- +goose Down` sections
- Never modify an existing migration after it has been applied — create a new one
- Run migrations on app startup:

```go
func RunMigrations(db *sql.DB, dir string) error {
    goose.SetDialect("sqlite3")
    return goose.Up(db, dir)
}
```

## Query Patterns

### Pagination
```sql
SELECT id, title FROM items
ORDER BY title ASC
LIMIT ? OFFSET ?
```
Always `ORDER BY` before `LIMIT`/`OFFSET` for consistent results.

### Upsert
```sql
INSERT INTO config (key, value) VALUES (?, ?)
ON CONFLICT(key) DO UPDATE SET value = excluded.value
```

### JSON fields
```sql
SELECT json_extract(settings, '$.baseUrl') FROM services WHERE id = ?
```

## Performance

- SQLite is fast enough for tens of thousands of records — don't over-optimize
- Use `EXPLAIN QUERY PLAN` to verify index usage on slow queries
- Batch inserts in a transaction:
  ```go
  tx, _ := db.BeginTx(ctx, nil)
  defer tx.Rollback()
  stmt, _ := tx.PrepareContext(ctx, "INSERT INTO items (name) VALUES (?)")
  for _, item := range items {
      stmt.ExecContext(ctx, item.Name)
  }
  tx.Commit()
  ```

## Backup

```sql
VACUUM INTO '/backups/app-2026-01-01.db'
```

Creates a consistent backup without stopping the application.

## Testing

Use an in-memory database for unit tests:

```go
func setupTestDB(t *testing.T) *sql.DB {
    t.Helper()
    db, err := sql.Open("sqlite", "file::memory:?cache=shared&_foreign_keys=ON")
    require.NoError(t, err)
    t.Cleanup(func() { db.Close() })
    require.NoError(t, goose.Up(db, "../../migrations"))
    return db
}
```

## Anti-patterns

- `SetMaxOpenConns > 1` — causes SQLITE_BUSY under concurrent writes
- Missing `_foreign_keys=ON` — FK constraints silently not enforced
- Missing `_busy_timeout` — immediate errors under concurrent access
- String concatenation in queries — SQL injection
- Storing binary blobs in SQLite — store file paths instead
- Not backing up WAL and SHM files alongside the main DB file
