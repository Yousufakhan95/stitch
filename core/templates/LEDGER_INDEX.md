# Ledger index

> Map ledger ids → files on each side. Keep in sync with `ledgers:` in `stitch.yaml`.
> See docs/ledgers.md in the Stitch kit.

| id | When to use | Side paths (relative to each root) |
|----|-------------|--------------------------------------|
| main | Default / catch-all | `docs/STITCH_LEDGER.md` on every side |
| <!-- billing | Payments domain | client: docs/ledgers/BILLING.md · server: docs/ledgers/BILLING.md --> |

## How to add a ledger

1. Create the markdown file on **each** side that will participate (copy `STITCH_LEDGER.md` template).
2. Add a row here and a `ledgers:` entry in `stitch.yaml`.
3. New slices set `ledger_id: <id>` in the CONTRACT PACKET.
4. Do not write slices into a ledger that isn’t registered.
