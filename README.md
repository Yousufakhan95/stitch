# Stitch

**Skills for AI coding agents that keep two sides of an API honest.**

Orchestrator. Client skill. Server skill. Contract + ledger templates.  
Copy them into your project and say *“Stitch this endpoint.”*

No runtime. No fingerprint tooling. Just enough process for Cursor / Claude Code.

## What’s in the box

| Path | What |
|------|------|
| `core/skills/stitch-orchestrator` | Coordinates; never edits app code |
| `core/skills/stitch-client` | Implements one consumer-side slice |
| `core/skills/stitch-server` | Implements one provider-side slice |
| `core/templates/` | Contract, result, ledger, ledger index |
| `core/rules/isolation.mdc` | One side per pass; don’t invent fields |
| `core/config/stitch.example.yaml` | Roots + optional multi-ledger map |
| `docs/HOW_TO_USE.md` | Install and run a slice |
| `docs/ADD_ON.md` | Microservices + teaching the orchestrator new skills |

## Start here

1. Read [docs/HOW_TO_USE.md](docs/HOW_TO_USE.md)  
2. Copy skills + templates into your client and server projects  
3. For more services or custom specialists → [docs/ADD_ON.md](docs/ADD_ON.md)

## License

MIT — see [LICENSE](LICENSE).
