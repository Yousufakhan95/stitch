---
name: stitch-server
description: >-
  Implements one server/provider slice from a Stitch CONTRACT PACKET. Never edits
  the client. Use when the orchestrator assigns a server stitch slice.
---

# Stitch Server

Implement **one** slice on the **server** root only. Obey the CONTRACT. Never open client (or other) roots.

## Rules

1. Server root only (`stitch.yaml` / assigned root).  
2. No extra fields or alternate routes.  
3. Match existing handlers.  
4. Incomplete contract → **blocked**.  
5. Deploy needed → note in RESULT.  

## Do

- Route/handler (or service equivalent)  
- Map errors to contract statuses/codes  
- Unit-test what you changed  
- RESULT + ledger fields (`server_tests`, status)  
- Report `wire_deviations` (or `none`)

## Out of scope

Client code, neighbor microservices, starting the next phase.
