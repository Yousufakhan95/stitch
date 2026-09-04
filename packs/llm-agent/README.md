# Pack: llm-agent

Optional principles for projects where an **LLM agent is part of the product** (not the coding assistant).

## Keep it light

- State machine over “chatbot with tools glued on”
- One job per node/step; prompts stay narrow
- Human-in-the-loop before irreversible mutations
- Inference rules belong in prompts + context pipeline, not vibes

## What this pack is not

Not a LangGraph tutorial. Not tied to any vendor. Drop a `SKILL.md` here when you want coding agents to respect your agent-craft rules while Sitching the APIs around them.

## Suggested skill stub

Create `packs/llm-agent/skills/agent-craft/SKILL.md` in your fork with your graph/prompt conventions. Keep product-specific model names and topics out of **core**.
