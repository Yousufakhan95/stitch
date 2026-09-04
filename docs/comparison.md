# Why not heavier?

## What Stitch is not

| Heavy approach | Stitch |
|----------------|-------|
| Custom agent runtime / orchestrator server | Skills + scripts agents already run |
| Plugin marketplace and SDK lock-in | Copy markdown + bash into your repo |
| “One agent edits the whole monorepo” | Explicit one-side rule |
| Generated RPC frameworks as the source of truth | Human-readable contract packets |
| Eval platforms required on day one | Optional `live-evals` pack |

## When to use something heavier

- You need multi-day autonomous jobs with durable workflow engines  
- You need org-wide agent policy servers  
- Your product *is* the agent platform  

Stitch is for **teams shipping apps with AI coding assistants**, not for building the assistant itself.

## The lightweight bet

Most FE/BE drift and agent thrash comes from missing **shared wire law** and missing **isolation**, not from missing a new runtime.

Stitch ships only that: packets, roles, ledger, fingerprint. Everything else is a pack or your stack.
