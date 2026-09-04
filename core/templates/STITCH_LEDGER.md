# STITCH LEDGER

> Maintained by the **sitch-orchestrator**. Specialists only update their side's test/status fields via RESULT packets; the orchestrator reconciles both copies.

## Active

<!-- Paste slice rows below. Keep the other side's ledger identical for active slices. -->

## Slice: <METHOD> <path>
slice_id:
ledger_id: main
status: contracted | server_done | client_done | slice_done | e2e_pass | blocked | phase_contract_verified
path_class:
clients:                                      # side ids that must implement; omit = defaults.client_pass
server_tests:
client_tests:
contract_fingerprint:
contract_checked_at:
wire_deviations:
blocked_reason:
contract: |
  <paste CONTRACT PACKET>
