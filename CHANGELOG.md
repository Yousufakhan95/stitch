# Changelog

## 0.2.0 — 2026-09-04

- Rename product consistently to **Stitch** (skills, config, docs, env `STITCH_*`)
- Add `core/scripts/gate.sh` + `stitch-gate` skill — enforces fingerprint and `require_tests` ledger evidence
- CI: MATCH fingerprint, **negative MISMATCH** (expect exit 2), and full gate pass on tiny-dual

## 0.1.1 — 2026-09-04

- README: how to use, how config works, how to customize for your product
- Docs: `how-it-runs.md`, `ledgers.md`, `customizing.md`
- Config: multi-`clients`, named `ledgers`, per-side `skill`, `ledger_index`
- Template: `LEDGER_INDEX.md`; contract/ledger rows gain `ledger_id` / `clients`

## 0.1.0 — 2026-09-03

- Initial public kit: core skills, templates, fingerprint + init/sync scripts
- Packs: dual-git-roots, monorepo, llm-agent, live-evals (stubs / patterns)
- Example: `examples/tiny-dual`
- Docs: concepts, workflows, comparison, marketing one-pager
