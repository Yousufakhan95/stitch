# Stitch

Stitch is a small set of **AI coding skills** that stop agents from inventing API fields or editing your client and server in the same pass.

You copy three skills (orchestrator, client, server) plus a few templates into your project. When you say “Stitch this endpoint,” the orchestrator writes a short contract, one specialist does the server, then one does the client. That’s the whole product — not a runtime, not a framework.

## What’s in the box

| Path | What |
|------|------|
| `core/skills/stitch-orchestrator` | Coordinates; never edits app code |
| `core/skills/stitch-client` | Implements one consumer-side slice |
| `core/skills/stitch-server` | Implements one provider-side slice |
| `core/templates/` | Contract, result, ledger, ledger index |
| `core/rules/isolation.mdc` | One side per pass; don’t invent fields |
| `core/config/stitch.example.yaml` | Roots + optional multi-ledger map |
| `docs/ADD_ON.md` | Microservices + teaching the orchestrator new skills |

## How to use

### 1. Copy into your projects

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

### 2. Run a slice

In Cursor / Claude Code (orchestrator skill available):

> Stitch `POST /api/widgets` using the orchestrator.

Expected loop:

1. Orchestrator writes a **CONTRACT PACKET** (from the template)  
2. Appends the same row to the **ledger** on each side  
3. Hands off to **stitch-server** only → RESULT  
4. Hands off to **stitch-client** only → RESULT  
5. Marks the slice done (or blocked with a reason)

One slice = one method + path (or one message shape). Finish it before starting another.

### 3. Multi-ledger (optional)

When one ledger file gets too big, split by domain:

1. Copy `STITCH_LEDGER.md` to e.g. `docs/ledgers/BILLING.md` on **each** side  
2. Register it in `stitch.yaml` under `ledgers:` and in `LEDGER_INDEX.md`  
3. Put `ledger_id: billing` on the CONTRACT / ledger row  

Orchestrator only appends that slice to the ledgers for that id. See the example block in `stitch.example.yaml`.

### 4. Rules of thumb

- Orchestrator never edits app code  
- Specialists never open the other side  
- Contract is law — no invented fields  
- If the wire shape must change, orchestrator amends the contract once, then re-runs the affected side  

More services or custom skills → [docs/ADD_ON.md](docs/ADD_ON.md).

## License

MIT — see [LICENSE](LICENSE).
