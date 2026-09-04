---
name: fingerprint-check
description: >-
  Computes and compares SHA-256 fingerprints of a canonical contract file across
  Stitch client and server roots. Use at phase boundaries, when verifying a
  contract lock, or when filling contract_fingerprint / wire_deviations in a ledger.
---

# Fingerprint Check

Stitch requires, at every phase boundary, that the canonical contract file be **byte-identical** across client and server, verified by SHA-256 and recorded in both ledgers.

## How to run

```bash
# from the stitch kit, or after init-project copied scripts into a project
./core/skills/fingerprint-check/scripts/check-fingerprint.sh <contract-filename>
```

Example:

```bash
./core/skills/fingerprint-check/scripts/check-fingerprint.sh hello-v1.md
```

Paths resolve from `stitch.yaml` or env:

| Env | Meaning |
|-----|---------|
| `STITCH_CLIENT_ROOT` | Client project root |
| `STITCH_SERVER_ROOT` | Server project root |
| `STITCH_CONFIG` | Optional path to `stitch.yaml` |

Bare filename → `{contracts_dir}/<file>` (default `docs/contracts/`).  
Path containing `/` → relative to each side's root.

## Reading the output

- **MATCH** (exit 0) — paste `contract_fingerprint`, `contract_checked_at`, `wire_deviations: none` into both ledgers.
- **MISMATCH** (exit 2) — do not mark `phase_contract_verified`. Diff, amend once via orchestrator, re-run.
- **MISSING** (exit 1) — file absent on one or both sides.
