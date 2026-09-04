# Ledgers

A **ledger** is a markdown file that tracks Sitch slices: status, tests, contract fingerprint, wire deviations, and the pasted CONTRACT PACKET.

Ledgers are **plain files in your repos**. Sitch does not host them.

## Default layout (one ledger per side)

```text
my-client/docs/STITCH_LEDGER.md
my-server/docs/STITCH_LEDGER.md
```

Declared in `sitch.yaml`:

```yaml
client:
  root: ../my-client
  ledger: docs/STITCH_LEDGER.md    # path relative to that root

server:
  root: ../my-server
  ledger: docs/STITCH_LEDGER.md
```

The orchestrator keeps **active rows identical** across sides for the slices in flight. Specialists only update their side’s `*_tests` / status fields via RESULT; the orchestrator reconciles.

## Why a copy on each side?

- Each git repo can review ledger history in PRs  
- A specialist locked to one root can still read “what’s contracted” without opening the other tree  
- Fingerprint + ledger row together are the phase gate  

## Multiple ledgers

Use more than one ledger when domains shouldn’t share a single scrolling file (billing vs chat vs admin), or when different client apps track work separately.

### 1. Feature / domain ledgers (same two roots)

```text
server/docs/ledgers/
  CORE.md
  BILLING.md
  CHAT.md
client/docs/ledgers/
  CORE.md
  BILLING.md
  CHAT.md
```

```yaml
# sitch.yaml
version: 1

server:
  root: ../my-server
  contracts_dir: docs/contracts
  api_structure: docs/api-structure.md
  # default ledger if a slice doesn't name one
  ledger: docs/ledgers/CORE.md

client:
  root: ../my-web
  contracts_dir: docs/contracts
  api_structure: docs/api-structure.md
  ledger: docs/ledgers/CORE.md

ledgers:
  - id: core
    description: Auth, users, shared primitives
    paths:
      client: docs/ledgers/CORE.md
      server: docs/ledgers/CORE.md
  - id: billing
    description: Plans, checkout, invoices
    paths:
      client: docs/ledgers/BILLING.md
      server: docs/ledgers/BILLING.md
  - id: chat
    description: Messaging and realtime
    paths:
      client: docs/ledgers/CHAT.md
      server: docs/ledgers/CHAT.md
```

In the CONTRACT PACKET / slice definition, set:

```text
ledger_id: billing
```

Orchestrator appends that slice only to the `billing` paths on each side.

### 2. Multiple clients (web + mobile + …)

Each client is a **side** with its own root and ledger path(s):

```yaml
version: 1

server:
  id: api
  root: ../my-api
  ledger: docs/STITCH_LEDGER.md
  contracts_dir: docs/contracts
  api_structure: docs/api-structure.md

clients:
  - id: web
    root: ../my-web
    ledger: docs/STITCH_LEDGER.md
    contracts_dir: docs/contracts
    api_structure: docs/api-structure.md
    skill: sitch-client          # or your custom skill name
  - id: mobile
    root: ../my-mobile
    ledger: docs/STITCH_LEDGER.md
    contracts_dir: docs/contracts
    api_structure: docs/api-structure.md
    skill: sitch-client-mobile   # custom specialist — see customizing.md

ledgers:
  - id: main
    paths:
      api: docs/STITCH_LEDGER.md
      web: docs/STITCH_LEDGER.md
      mobile: docs/STITCH_LEDGER.md
```

Flow change: after server RESULT, orchestrator runs **one client specialist pass per client** listed on the slice (`clients: [web, mobile]` or default “all”).

Fingerprint compares the contract file across **every side** that must implement that slice (not only two).

### 3. Monorepo

Same rules — paths are under packages:

```text
packages/web/docs/STITCH_LEDGER.md
packages/api/docs/STITCH_LEDGER.md
packages/mobile/docs/STITCH_LEDGER.md
```

## Registry file (optional but recommended)

Keep a short index so humans and agents know which ledger to open:

**`docs/LEDGER_INDEX.md`** (workspace or server root):

```markdown
# Ledger index

| id | When to use | client path | server path |
|----|-------------|-------------|-------------|
| core | default / shared | docs/ledgers/CORE.md | docs/ledgers/CORE.md |
| billing | payments | docs/ledgers/BILLING.md | docs/ledgers/BILLING.md |
```

Point `sitch.yaml` at it:

```yaml
ledger_index: docs/LEDGER_INDEX.md
```

Template: [`../core/templates/LEDGER_INDEX.md`](../core/templates/LEDGER_INDEX.md).

## Row shape

Use [`../core/templates/STITCH_LEDGER.md`](../core/templates/STITCH_LEDGER.md). Every active slice row should include `ledger_id` when you use more than one ledger.

## Rules of thumb

| Situation | Recommendation |
|-----------|----------------|
| One web app + one API | One ledger file per side (`STITCH_LEDGER.md`) |
| Large product, many domains | Domain ledgers + `ledgers:` registry |
| Web + mobile | `clients:` list; shared or per-client ledger paths |
| Experiments / spikes | Separate ledger id (`spike`) so main stays clean |

Do **not** invent a ledger path mid-slice. Add it to `sitch.yaml` + `LEDGER_INDEX.md` first, then contract.
