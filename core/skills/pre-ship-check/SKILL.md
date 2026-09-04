---
name: pre-ship-check
description: >-
  Local pre-push gate for a Stitch-managed project — run the side's standard
  tests (and build if applicable) before pushing to a deploy-tracked branch.
  Use before shipping client or server changes.
---

# Pre-Ship Check

Skills remind; CI should eventually enforce. Until then, run this before push to any branch that deploys.

## Client

From the client root (`stitch.yaml` → `client.root`):

```bash
# adapt to the project — examples:
npm test -- --watchAll=false
npm run build
# or: pnpm test && pnpm build
# or: vitest run && vite build
```

## Server

From the server root:

```bash
# adapt to the project — examples:
go test ./...
go vet ./...
# or: pytest
# or: cargo test
```

## Rules

- Do not push known-red tests to deploy-tracked branches.
- If you touched shared contracts, run **fingerprint-check** too.
- Prefer adding the same commands to CI so this skill is a backup, not the only gate.
- After tests + ledger updates, run **`./core/scripts/gate.sh --contract <file>`** so `require_tests` is actually checked (see `stitch-gate` skill).
