# Workflows

## Slice lifecycle

```text
1. Define slice from api-structure (or invent the structure doc if new)
2. Write CONTRACT PACKET; append ledger row on both sides (same text)
3. Server specialist → RESULT PACKET
4. Deploy/restart gate if the environment needs it (ask the human)
5. Client specialist → RESULT PACKET (same contract; amend first if server drifted)
6. Orchestrator verify: tests reported + smoke against live or staging
7. Feature E2E only when all slices for that feature are green
8. Phase boundary: run fingerprint; record MATCH in both ledgers
```

## CONTRACT PACKET shape

```text
## CONTRACT
slice_id: <feature>/<METHOD>_<path_slug>
method: GET|POST|PATCH|PUT|DELETE|WS
path: /api/...
path_class: <from sitch.yaml or "default">
auth: required|none

### Request
<json example or "empty">

### Response 200
<json example>

### Errors
- <status>: <code> — <when>

### Do not invent
- fields not listed above
- alternate paths
```

## RESULT PACKET shape

```text
## RESULT
slice_id:
repo: client|server
status: done|blocked
files_changed:
tests_run:
tests_passed: true|false
contract_fingerprint:
wire_deviations: none|<exact deviations>
notes:
deploy_needed: true|false
blocked_reason:
```

If `wire_deviations` is not `none`, orchestrator amends the contract before the other side proceeds.

## Phase boundary checklist

1. Canonical contract file identical on both sides (`check-fingerprint.sh`)
2. Active ledger rows agree on contract body + fingerprint
3. Specialists reported fingerprint + deviations
4. Only then mark `phase_contract_verified` and start the next phase

## Agent prompts (cheat sheet)

**Orchestrator → server**

- Full CONTRACT PACKET  
- “Edit only the server root from `sitch.yaml`. Do not touch the client.”  
- “Follow `sitch-server` skill. Return a RESULT PACKET.”

**Orchestrator → client**

- Same CONTRACT PACKET  
- Server RESULT (if shapes adjusted, amend contract first)  
- “Edit only the client root. Follow `sitch-client`. Return RESULT.”
