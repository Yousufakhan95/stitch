# Pack: live-evals

Optional pattern for **gated live-model golden evals** (real LLM, fixture data, opt-in).

## Idea

```text
GoldenCases → live harness (env gate) → real model + fixtures → scorer → pass/fail + trace
```

- Offline fake-model tests stay in CI  
- Live runs require an explicit env flag + API key  
- Never enable live calls in default CI  

## Why a pack, not core

Most Stitch users stitch CRUD APIs. Live evals matter when the model *is* the product surface. Keep token spend opt-in.

## Stub checklist for your language

1. Golden case list (utterance + expected intent/ops)  
2. Fixture world (no production DB)  
3. Env gate (`LIVE_EVALS=1`)  
4. Scorer: hard fails vs soft logs  
5. Filter by case name for fast iteration  

Implement in your stack (Go `testing`, pytest, Vitest, etc.). Core Stitch does not ship a model client.
