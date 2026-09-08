# Ledger index

Map ledger ids → files on each side. Keep in sync with `ledgers:` in `stitch.yaml`.

| id | When to use | Paths (per side) |
|----|-------------|------------------|
| main | Default | `docs/STITCH_LEDGER.md` on each participating side |

## Add a ledger

1. Copy `STITCH_LEDGER.md` onto each side that will use it (e.g. `docs/ledgers/BILLING.md`).  
2. Add a row here and a `ledgers:` entry in `stitch.yaml`.  
3. New slices set `ledger_id: <id>` on the CONTRACT.  
4. Don’t write slices into an unregistered ledger.
