---
applyTo: "**/*.py"
---

# Python Conventions

## Type Hints
- Type hints on all function signatures
- Use Python 3.12+ union syntax: `str | None` (not `Optional[str]`)
- Use `from __future__ import annotations` if needed for older Python

## Async
- Prefer `async def` for I/O-bound operations
- Use `asyncio` patterns consistent with FastAPI

## Dependencies
- Use `uv` for dependency management (never pip directly)
- Use `pydantic` for settings, validation, and request/response models
- Cache settings with `@lru_cache`: one settings instance per process

## FastAPI
- Routers in `routers/` directory, one file per domain (e.g., `routers/users.py`)
- Use `APIRouter` with prefix and tags: `router = APIRouter(prefix="/users", tags=["users"])`
- Pydantic models for all request bodies and responses — never raw dicts
- Use `Depends()` for dependency injection (database sessions, auth, settings)
- Async path operations for I/O-bound endpoints
- Use `HTTPException` for error responses with appropriate status codes
- Use `status` constants: `status.HTTP_201_CREATED` (not magic numbers)
- Lifespan handler for startup/shutdown (not deprecated `on_event`)

## Structure
- snake_case for functions, modules, variables
- PascalCase for classes and type names
- One class per file when the class is substantial
- Group imports: stdlib → third-party → local (enforced by ruff)

## Testing
- Use `pytest` with fixtures
- Mirror `src/` structure in `tests/`
- Mark integration tests with `@pytest.mark.integration`
- Async tests: use `pytest-asyncio` with auto mode
- Use `httpx.AsyncClient` with `ASGITransport` for testing FastAPI endpoints

## Logging
- Use `structlog` with JSON rendering for structured logs
- Create logger per module: `structlog.get_logger(__name__)`
