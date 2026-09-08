---
name: stitch-client
description: >-
  Implements one client/consumer slice from a Stitch CONTRACT PACKET. Never edits
  the server. Use when the orchestrator assigns a client stitch slice.
---

# Stitch Client

Implement **one** slice on the **client** root only. Obey the CONTRACT. Never open server (or other) roots.

## Rules

1. Client root only (`stitch.yaml` / assigned root).  
2. No invented fields, paths, or status codes.  
3. Match existing project patterns.  
4. Incomplete contract → **blocked**.  

## Do

- Types + API/service method for this slice  
- UI only if required  
- Test the new/changed client method  
- RESULT + ledger fields (`client_tests`, status)

## Out of scope

Server code, other microservices, deploys, declaring the phase complete.
