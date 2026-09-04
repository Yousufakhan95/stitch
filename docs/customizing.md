# Customizing Stitch

Core stays thin. Your product’s conventions live in **config**, **extra skills**, and **rules** you add beside core — not by forking the idea of packets/ledgers.

## 1. Edit `stitch.yaml` first

Copy `core/config/stitch.example.yaml` → `stitch.yaml` at your workspace root.

Adjust:

| Field | Why |
|-------|-----|
| `client` / `clients` / `server` roots | Where specialists are allowed to edit |
| `ledger` / `ledgers` | Where slice status lives — see [ledgers.md](ledgers.md) |
| `contracts_dir` | Where fingerprinted contract files live |
| `path_classes` | Your routing vocabulary (`default`, `kafka`, `graphql`, …) |
| `defaults.server_first` | Flip if you freeze client shapes first |

Agents should read this file instead of hardcoding repo names.

## 2. Add rules (always-on guardrails)

Drop markdown rules into each side:

```text
my-web/.cursor/rules/stitch-isolation.mdc     # from core
my-web/.cursor/rules/web-conventions.mdc     # yours
my-api/.cursor/rules/stitch-isolation.mdc
my-api/.cursor/rules/api-error-codes.mdc     # yours
```

Examples of **your** rules:

- “Client IDs are strings; never number”
- “All public errors use `{ code, message }`”
- “Mobile specialist must not touch Next.js app router”

Keep Stitch isolation as the base; layer product rules on top.

## 3. Add or fork skills

### Same role, different stack

Copy a core skill and rename:

```text
core/skills/stitch-client/SKILL.md
  → my-web/.cursor/skills/stitch-client/SKILL.md          (stock)
  → my-mobile/.cursor/skills/stitch-client-mobile/SKILL.md (fork)
```

In the fork, change only the “Where to work” / test commands / UI notes — keep CONTRACT/RESULT discipline.

Register in config:

```yaml
clients:
  - id: web
    root: ../my-web
    skill: stitch-client
  - id: mobile
    root: ../my-mobile
    skill: stitch-client-mobile
```

Orchestrator prompt: “Follow skill `<skill>` for side `<id>`.”

### New specialist types

Examples worth adding as **your** skills (not required in core):

| Skill name | Use |
|------------|-----|
| `stitch-client-cli` | CLI / TUI consumer of the same API |
| `stitch-client-admin` | Separate admin SPA |
| `stitch-worker` | Async consumer that must honor the same envelope |
| `stitch-docs` | OpenAPI / public docs only (no app code) |

Pattern: one side root + obey CONTRACT + return RESULT + never edit other roots.

### Packs

Optional kits under `packs/`:

- `dual-git-roots` — sibling repos  
- `monorepo` — packages in one git root  
- `llm-agent` — when an LLM is product surface  
- `live-evals` — gated live-model goldens  

Copy a pack README into your workspace and add skills under `.cursor/skills/` as needed.

## 4. Sync copies so they don’t drift

After you change a skill in the kit or a canonical copy:

```bash
./core/scripts/sync-skills.sh /path/to/client /path/to/server
```

For custom skills not in core, keep a single canonical folder (e.g. `workspace/skills/`) and sync that yourself — or document “web skill lives only in my-web.”

## 5. Contracts and path classes

- Put locked wire docs in each side’s `contracts_dir` (byte-identical for fingerprint).  
- Extend `path_classes` in YAML so specialists know *how* work runs on the server without inventing RPC styles.

```yaml
path_classes:
  - id: default
    description: In-process HTTP handler
  - id: queue
    description: Enqueue command; reply on bus
  - id: ws
    description: Websocket frames per contract
```

## 6. What not to customize away

These are the product — changing them usually means you’re not using Stitch anymore:

1. One specialist, one side per pass  
2. CONTRACT PACKET is law (no invented fields)  
3. RESULT PACKET + ledger updates  
4. Fingerprint match before the next phase  

Everything else — folder layout, test runners, number of clients, domain ledgers, extra rules — should bend to your team.
