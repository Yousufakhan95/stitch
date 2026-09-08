# How to use Stitch

## 1. Copy into your projects

Put these on **both** the client and server (or monorepo packages):

- `core/skills/stitch-orchestrator` → `.cursor/skills/stitch-orchestrator` (and `.claude/skills/` if you use Claude Code)
- `core/skills/stitch-client` → same under skills
- `core/skills/stitch-server` → same under skills
- `core/rules/isolation.mdc` → `.cursor/rules/stitch-isolation.mdc`
- Templates from `core/templates/` into each side’s `docs/` as you need them

Copy `core/config/stitch.example.yaml` to a workspace `stitch.yaml` and set roots:

```yaml
version: 1

client:
  root: ../my-app
  ledger: docs/STITCH_LEDGER.md

server:
  root: ../my-api
  ledger: docs/STITCH_LEDGER.md
```

## 2. Run a slice

In Cursor / Claude Code (orchestrator skill available):

> Stitch `POST /api/widgets` using the orchestrator.

Expected loop:

1. Orchestrator writes a **CONTRACT PACKET** (from the template)  
2. Appends the same row to the **ledger** on each side  
3. Hands off to **stitch-server** only → RESULT  
4. Hands off to **stitch-client** only → RESULT  
5. Marks the slice done (or blocked with a reason)

One slice = one method + path (or one message shape). Finish it before starting another.

## 3. Multi-ledger (optional)

When one ledger file gets too big, split by domain:

1. Copy `STITCH_LEDGER.md` to e.g. `docs/ledgers/BILLING.md` on **each** side  
2. Register it in `stitch.yaml` under `ledgers:` and in `LEDGER_INDEX.md`  
3. Put `ledger_id: billing` on the CONTRACT / ledger row  

Orchestrator only appends that slice to the ledgers for that id. See the example block in `stitch.example.yaml`.

## 4. Rules of thumb

- Orchestrator never edits app code  
- Specialists never open the other side  
- Contract is law — no invented fields  
- If the wire shape must change, orchestrator amends the contract once, then re-runs the affected side  

More services or custom skills → [ADD_ON.md](ADD_ON.md).
