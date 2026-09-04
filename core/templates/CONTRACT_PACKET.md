## CONTRACT
slice_id: <feature>/<METHOD>_<path_slug>
ledger_id: main
clients: [web]                    # side ids from sitch.yaml; omit = all / first per defaults
method: GET|POST|PATCH|PUT|DELETE|WS
path: /api/...
path_class: default
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
- status codes not listed above
