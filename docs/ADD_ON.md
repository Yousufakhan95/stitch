# Add-on: microservices and extra skills

Use this when the default **one client + one server** isn’t enough — e.g. a gateway plus users/calendar workers, or a mobile client with its own conventions.

## 1. Extra specialist skills

Copy `stitch-server` or `stitch-client` and rename:

```text
.cursor/skills/stitch-users/SKILL.md
.cursor/skills/stitch-calendar/SKILL.md
.cursor/skills/stitch-client-mobile/SKILL.md
```

Change only:

- Which **root** that skill may edit  
- Where code/tests live in that service  
- Stack-specific notes (Go package, Nest module, etc.)  

Keep: obey CONTRACT, one side only, return RESULT, don’t invent fields.

## 2. Tell the orchestrator about them

In `stitch.yaml`, map side ids → skill names and roots:

```yaml
version: 1

client:
  id: web
  root: ../web
  skill: stitch-client
  ledger: docs/STITCH_LEDGER.md

# Extra consumers
clients:
  - id: mobile
    root: ../mobile
    skill: stitch-client-mobile
    ledger: docs/STITCH_LEDGER.md

server:
  id: gateway
  root: ../gateway
  skill: stitch-server
  ledger: docs/STITCH_LEDGER.md

# Extra providers (microservices)
servers:
  - id: users
    root: ../users
    skill: stitch-users
    ledger: docs/STITCH_LEDGER.md
  - id: calendar
    root: ../calendar
    skill: stitch-calendar
    ledger: docs/STITCH_LEDGER.md
```

On the CONTRACT PACKET, name who implements the slice:

```text
servers: [users]          # or [gateway] or [users, calendar] if both must change
clients: [web, mobile]    # who must consume the new shape
ledger_id: main
```

## 3. Orchestrator behavior (what to say / encode)

When you run a slice, the orchestrator should:

1. Read `stitch.yaml` for roots + `skill:` per side id  
2. Write one CONTRACT (shared law for everyone on this slice)  
3. For each id in `servers:` — spawn **only** that skill, scoped to that root, with the CONTRACT → wait for RESULT  
4. For each id in `clients:` — same with client skills  
5. Update the ledger(s) for `ledger_id` on every participating side  

Prompt pattern for a handoff:

> Follow skill `stitch-users`. Edit only root `../users`. Here is the CONTRACT PACKET. Return a RESULT PACKET. Do not open any other repo.

Do **not** ask one agent to edit gateway + users + web in a single pass.

## 4. Path classes (optional vocabulary)

If work isn’t “plain HTTP on one process,” label it on the contract and teach specialists in their skill text:

| `path_class` | Meaning (you define) |
|--------------|----------------------|
| `default` | In-process handler |
| `async` | Command on a bus/queue |
| `stream` | Websocket / chunked replies |

Put the table in `stitch.yaml` or in each microservice skill. Orchestrator picks the specialist from the side id; the skill knows how that service implements the class.

## 5. Multi-ledger with many services

Same as [HOW_TO_USE.md](HOW_TO_USE.md): register `ledgers:` paths **per side id**. A billing slice might touch `web` + `users` ledgers only — don’t force calendar’s ledger to take a row.

## 6. What not to do

- Invent a second orchestrator per microservice  
- Let a specialist “also fix” a neighbor service  
- Skip the CONTRACT because “it’s internal Kafka” — internal shapes still drift  

Add skills; point the orchestrator at them with YAML + CONTRACT side lists. That’s the whole add-on model.
