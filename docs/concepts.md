# Concepts

## Boundary

A **boundary** is any place two codebases (or packages) must agree on a wire shape: HTTP path + JSON, WS frames, RPC, events.

Stitch only cares about boundaries. Everything else is your app.

## Roles

| Role | Job | Edits app code? |
|------|-----|-----------------|
| **Orchestrator** | Owns CONTRACT PACKET, dual ledgers, fingerprint gate; spawns one specialist at a time | No |
| **Server specialist** | Implements one slice on the server side | Server only |
| **Client specialist** | Implements the same slice on the client side | Client only |

## CONTRACT PACKET

A short, immutable (for the slice) description of method, path, auth, request, response, errors, and an explicit **Do not invent** list.

If a specialist needs a field that isn't in the packet, they **block** and return to the orchestrator. The orchestrator amends the contract once; both sides get the new bytes.

## Ledger

Markdown file(s) **in your repos** track each slice: status, tests, fingerprint, wire deviations, and the pasted contract.

Default: one `docs/STITCH_LEDGER.md` per side. You can register **multiple** domain ledgers and multiple clients in `stitch.yaml`.

Orchestrator keeps active rows aligned across sides. Specialists only fill their test/status fields.

Details: [ledgers.md](ledgers.md).

## Fingerprint

SHA-256 of the **canonical contract file** on both sides. Match → record in ledger → next phase allowed. Mismatch → stop, amend, re-run.

Never treat two independently edited prose summaries as synchronized. Hash the same bytes.

## Slice

One method + path (or one WS frame flow). Finish its gates before starting the next. No “while you're in users, also fix billing.”

## Path class (optional)

Projects may define routing classes (`local`, `async`, `stream`, …) in `stitch.yaml`. Core Stitch does not require Kafka, gateways, or any specific stack — those live in your config or a pack.
