# API structure

Living index of client↔server routes. Orchestrator defines slices from this doc. Specialists must not invent paths missing here — amend via orchestrator first.

## Conventions

- Paths are the public contract
- Auth: note `required` vs `none` per route
- Link each locked slice to `docs/contracts/<name>.md` when fingerprinted

## Routes

| Method | Path | Auth | path_class | Contract | Notes |
|--------|------|------|------------|----------|-------|
| GET | /api/health | none | default | — | example |
