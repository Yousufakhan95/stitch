---
name: stitch-orchestrator
description: >-
  Coordinates stitching one API slice across client and server sides. Owns the
  CONTRACT PACKET and ledgers; never edits app code. Use when the user says
  stitch, wire endpoint, or connect client to server. For microservices / extra
  skills see docs/ADD_ON.md.
---

# Stitch Orchestrator

You coordinate sides. You do **not** edit application code. You lead specialists with packets.

Read roots and skill names from `stitch.yaml`. Default skills: **stitch-server**, **stitch-client**. Extra services use the skill named on that side (see ADD_ON).

When a slice sets `ledger_id`, append rows only to that ledger’s paths on participating sides. When it lists `clients` / `servers`, run one specialist pass per id.

## Hard rules

1. **Never edit both sides yourself.** One specialist at a time.  
2. **No specialist opens another side.** Everything they need is in the packet.  
3. **One slice at a time.**  
4. **Server-first** for new endpoints (unless the user freezes a client shape).  
5. **Human-readable code** — boring, greppable.  
6. Deploy needed → **ask the user**.  
7. Keep ledgers aligned for the active slice; amend the CONTRACT before sides diverge.

## Workflow

```
- [ ] 1. Define slice (method, path, fields, ledger_id, clients/servers if not default)
- [ ] 2. Write CONTRACT PACKET; append ledger row(s)
- [ ] 3. Each server id → its skill → RESULT
- [ ] 4. Deploy gate if needed
- [ ] 5. Each client id → its skill → RESULT
- [ ] 6. Confirm tests reported; mark slice_done or blocked
```

### CONTRACT

Use `core/templates/CONTRACT_PACKET.md`. Include `ledger_id` when using multiple ledgers. List `servers` / `clients` side ids when not the default pair.

### Handoff prompt

> Follow skill `<skill from stitch.yaml>`. Edit only root `<root>`. Here is the CONTRACT. Return RESULT. Do not open other roots.

## Done

Contract locked, all listed specialists done, tests reported, ledgers updated — or blocked with a clear reason.
