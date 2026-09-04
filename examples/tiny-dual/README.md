# tiny-dual

Minimal fake **client** + **server** docs that demonstrate a Stitch lock — no real app code.

## What's here

| Path | Purpose |
|------|---------|
| `client/` | Client-side api-structure, ledger, contract copy |
| `server/` | Server-side mirrors |
| `stitch.yaml` | Points at both roots |
| `docs/contracts/hello-v1.md` | Canonical contract (identical bytes both sides) |

## Try fingerprint + gate

From `examples/tiny-dual`:

```bash
../../core/skills/fingerprint-check/scripts/check-fingerprint.sh hello-v1.md
../../core/scripts/gate.sh --contract hello-v1.md
```

Expect **MATCH** / **gate: PASS**.

## Feel the workflow

1. Read `hello-v1.md` — that's the law for `GET /api/hello`  
2. Imagine a server specialist implementing only `server/`  
3. Imagine a client specialist implementing only `client/`  
4. Phase boundary → gate → next slice  

No HTTP server required. This example is for process, not runtime.
