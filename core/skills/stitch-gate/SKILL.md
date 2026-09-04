---
name: stitch-gate
description: >-
  Run the Stitch gate CLI — fingerprint plus require_tests ledger evidence.
  Use at phase boundaries, before marking slice_done, or in CI. Prefer this over
  trusting prose-only pre-ship reminders when defaults.require_tests is true.
---

# Stitch Gate

`require_tests: true` in `stitch.yaml` is **not** self-enforcing. This skill runs
`core/scripts/gate.sh`, which fails closed.

## How to run

From a workspace with `stitch.yaml` (or env roots set):

```bash
./core/scripts/gate.sh --contract hello-v1.md
```

Exit codes:

| Code | Meaning |
|------|---------|
| 0 | Fingerprint MATCH + ledger test fields OK |
| 1 | Usage / missing config |
| 2 | Fingerprint MISMATCH or missing |
| 3 | `require_tests` violated — empty `server_tests` / `client_tests` on progressed slices |

## What “test evidence” means

Gate does **not** execute `npm test` / `go test`. It refuses empty ledger fields when status is past `contracted` (e.g. `server_done`, `slice_done`, `phase_contract_verified`). Specialists must record the command run, or an explicit `n/a` with reason.

## Flags

- `--skip-ledger-tests` — fingerprint only (escape hatch; do not use to greenwash CI)
- `--contract <file>` — required unless `hello-v1.md` exists on the client

## Related

- `fingerprint-check` — hash-only
- `pre-ship-check` — reminds you to run real tests; gate checks the ledger recorded them
