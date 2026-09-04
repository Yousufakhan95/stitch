# Sitch — one-pager

## Tagline

**Boundary discipline for AI coding agents — without a framework.**

## Problem

AI agents invent API fields, edit client and server in the same pass, and declare “done” without a shared wire lock. Heavier harnesses solve this by adding runtimes. Teams don't adopt runtimes.

## Solution

Sitch is a **lightweight harness**: Cursor/Claude skills, contract/ledger templates, and a SHA-256 fingerprint script. Orchestrator owns the contract; specialists implement one side; both sides must hash-match before the next phase.

## Who it's for

- Dual-repo or client/server monorepo teams using Cursor, Claude Code, or similar  
- Founders who want process agents can follow, not a platform to operate  

## What's included

- `sitch-orchestrator` / `sitch-client` / `sitch-server` skills  
- Contract + result + ledger templates  
- `check-fingerprint.sh` + `init-project.sh`  
- Optional packs (dual roots, monorepo, LLM craft, live evals)  
- `examples/tiny-dual`  

## Differentiator

**Boring on purpose.** Greppable contracts. One slice. No daemon. MIT.

## Call to action

Clone → `init-project.sh` → say “Sitch this endpoint.”
