# Stitch

**Lightweight boundary harness for agentic coding.**

Contracts. One side at a time. Ledgers. Fingerprints.  
Not a runtime. Not an agent OS. Not another framework to learn.

Stitch is a small set of **skills + templates + scripts** that keep AI coding agents from inventing API fields, editing both sides of a split in one pass, or shipping without a recorded wire lock.

```text
you ask → orchestrator (contract + ledger) → server specialist → client specialist(s) → fingerprint → next slice
```

Nothing runs in the background. Agents read the skills; `stitch.yaml` tells them where your sides and ledgers live.

## Quick start — what you do

1. **Install into your projects**

   ```bash
   ./core/scripts/init-project.sh /path/to/your-client /path/to/your-server
   ```

   Or manually: copy `core/skills/` → each side’s `.cursor/skills/` and `.claude/skills/`, copy `core/rules/isolation.mdc`, copy ledger/api templates into `docs/`.

2. **Edit `stitch.yaml`** (created next to the script cwd, or copy from `core/config/stitch.example.yaml`)

   - Set `client.root` / `server.root` (or a `clients:` list for web + mobile + …)
   - Confirm `ledger`, `contracts_dir`, `api_structure` paths
   - Adjust `path_classes` to match *your* stack vocabulary

3. **Open the workspace in Cursor / Claude Code** so those skills load.

4. **Stitch a slice** — e.g. *“Stitch POST /api/widgets using the orchestrator skill.”*

   The agent should: write a CONTRACT PACKET → update ledgers → run **server** specialist only → then **client** specialist(s) → run **gate** (fingerprint + ledger test evidence) at the phase boundary.

5. **Before you push**, run real tests on each side, then:

   ```bash
   ./core/scripts/gate.sh --contract <locked-contract.md>
   ```

   `require_tests: true` is enforced here (non-empty ledger test fields), not by hope.

Try the docs-only demo first: [`examples/tiny-dual`](examples/tiny-dual).

## How it runs (flow)

```text
┌─────────────────────────────────────────────────────────┐
│ stitch.yaml = map of roots, ledgers, skills, path_classes│
└─────────────────────────────────────────────────────────┘
                          │
You: "Stitch GET /api/hello"
                          ▼
              stitch-orchestrator
                 │ writes CONTRACT
                 │ appends ledger row(s)
                 ▼
              stitch-server  (server.root only) → RESULT
                 ▼
              stitch-client  (each clients[].root) → RESULT
                 ▼
              gate.sh (fingerprint + require_tests ledger evidence)
                 ▼
              record fingerprint in ledger(s) → slice_done
```

| Piece | What it is |
|-------|------------|
| **Orchestrator** | Coordinates only — no app code edits |
| **Specialists** | One side per pass (`stitch-server`, `stitch-client`, or your forks) |
| **CONTRACT PACKET** | Law for the slice — no invented fields |
| **Ledger(s)** | Markdown status files **in your repos** — see [docs/ledgers.md](docs/ledgers.md) |
| **`stitch.yaml`** | Config map — paths and options, not a runtime |
| **Fingerprint** | SHA-256 proves both sides’ contract files match |
| **Gate** | CLI that fails on MISMATCH or empty test fields when `require_tests: true` |

Full walkthrough: [docs/how-it-runs.md](docs/how-it-runs.md).

## What `stitch.yaml` is for

Config answers:

- Where is the server? Where are the clients?
- Which file is the ledger on each side? (or which **named** ledgers — billing vs chat)
- Which skill name to invoke per side (`stitch-client` vs `stitch-client-mobile`)
- What do `path_class` labels mean in *this* product?

It does **not** execute agents. It’s the shared map so skills stay generic and your layout stays yours.

## Customize for your product

Stitch is meant to be adjusted:

| You want… | Do this |
|-----------|---------|
| Web + mobile + API | Use `clients:` in YAML; one specialist pass per client — [customizing](docs/customizing.md) |
| Domain ledgers | Add `ledgers:` + `docs/LEDGER_INDEX.md` — [ledgers](docs/ledgers.md) |
| Different client conventions | Fork `stitch-client` → e.g. `stitch-client-mobile`; set `skill:` on that client |
| Always-on team rules | Add `.cursor/rules/*.mdc` beside `stitch-isolation` |
| Queue / WS / GraphQL | Extend `path_classes`; teach specialists in skill text |
| Monorepo vs two git repos | See `packs/monorepo` or `packs/dual-git-roots` |

**Keep:** one side per pass, contract law, RESULT + ledger, fingerprint before next phase.  
**Change:** folders, skills, rules, number of clients, ledger split.

Step-by-step: [docs/customizing.md](docs/customizing.md).

## What's in the box

| Path | Role |
|------|------|
| `core/` | Required — skills, templates, fingerprint, init/sync scripts, config examples |
| `packs/` | Optional — dual roots, monorepo, llm-agent, live-evals |
| `examples/tiny-dual/` | Fake client + server + one locked contract |
| `docs/` | How it runs, ledgers, customizing, concepts, comparison |

## Core ideas

1. **Orchestrator** never edits app code — only packets and ledgers  
2. **One specialist, one side** — never both in one pass  
3. **CONTRACT PACKET is law** — no invented fields, paths, or status codes  
4. **Fingerprint gate** — byte-identical contract files across sides before the next phase  
5. **Human-readable** — greppable names, boring handlers, boring services  
6. **Config + skills are yours to extend** — core stays the boundary discipline  

## Docs

- [How it runs](docs/how-it-runs.md)
- [Ledgers (where they live, multiple ledgers)](docs/ledgers.md)
- [Customizing (rules, skills, multi-client)](docs/customizing.md)
- [Concepts](docs/concepts.md)
- [Workflows](docs/workflows.md)
- [Why not heavier?](docs/comparison.md)
- [One-pager](docs/marketing-one-pager.md)

## License

MIT — see [LICENSE](LICENSE).
