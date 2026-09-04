# How Stitch runs

Stitch is **not a daemon**. Nothing “starts” in the background. A coding agent (Cursor, Claude Code, etc.) reads the skills and follows the workflow when you ask it to stitch a slice.

```text
You: "Stitch POST /api/widgets"
        │
        ▼
┌───────────────────┐
│  stitch-orchestrator│  reads stitch.yaml → knows roots, ledgers, path_classes
└─────────┬─────────┘
          │ writes CONTRACT PACKET
          │ appends row to every ledger listed for this slice
          ▼
┌───────────────────┐
│  stitch-server      │  edits server root only → RESULT PACKET
└─────────┬─────────┘
          │ (optional deploy gate — ask human)
          ▼
┌───────────────────┐
│  stitch-client      │  one pass per client side (web, mobile, …)
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│  fingerprint-check │  SHA-256 contract file on each side → MATCH?
└─────────┬─────────┘
          │ record fingerprint in ledgers
          ▼
       slice_done / next slice
```

## Who does what

| Actor | Runs when | Does |
|-------|-----------|------|
| **You** | Anytime | Name the slice; approve deploys; say when a feature is “done enough” for E2E |
| **Orchestrator skill** | You attach it / say “stitch” | Owns contract + ledgers; spawns one specialist at a time; never edits app code |
| **Server skill** | Orchestrator hands off | Implements the slice in `server.root` only |
| **Client skill** | After server (default) | Implements the slice in one `clients[].root` only |
| **Fingerprint script** | Phase boundary | Proves contract bytes match across sides |
| **Gate CLI** | Phase boundary / CI | Fingerprint + fails if `require_tests` and ledger test fields are empty |
| **Pre-ship skill** | Before push | Reminds you to run that side’s tests/build |

## Where `stitch.yaml` fits

Config is the **map**, not the engine:

- Which folders are “client” vs “server”
- Where each side’s ledger and contracts live
- Your `path_classes` vocabulary (`default`, `async`, `stream`, or whatever your stack uses)
- Defaults (server-first, require tests, fingerprint at phase boundary)

`require_tests: true` is enforced by **`gate.sh`**, not by YAML alone.

Agents and scripts read config so skills stay product-agnostic. You edit YAML for your layout; you edit skills/rules for your conventions.

See [Ledgers](ledgers.md) and [Customizing](customizing.md).
