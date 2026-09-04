# Pack: dual-git-roots

Use when client and server are **sibling git repositories** (two remotes, two PRs).

## Layout

```text
workspace/
  sitch.yaml          # roots point at ./my-client and ./my-server
  my-client/          # git repo A
  my-server/          # git repo B
```

## Rules

- Orchestrator may see both; specialists get one root only.
- Canonical contract file must exist in **both** `docs/contracts/` and fingerprint-match.
- Ledgers live in both repos; orchestrator keeps active rows identical.

## Install

```bash
./core/scripts/init-project.sh ./my-client ./my-server
```
