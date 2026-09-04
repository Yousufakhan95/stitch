# hello-v1

Locked contract for the tiny-dual example. Bytes must match on client and server.

## CONTRACT
slice_id: demo/GET_api_hello
method: GET
path: /api/hello
path_class: default
auth: none

### Request
empty

### Response 200
```json
{
  "message": "hello",
  "version": 1
}
```

### Errors
- 500: internal — unexpected server error

### Do not invent
- fields not listed above
- alternate paths
- query parameters
