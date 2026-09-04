# Pack: monorepo

Use when client and server are **packages in one git repository**.

## Layout

```text
repo/
  sitch.yaml
  packages/client/
  packages/server/
  docs/contracts/     # optional single source — still copy or link into both packages if you dual-ledger
```

## Config sketch

```yaml
client:
  root: ./packages/client
server:
  root: ./packages/server
```

## Note

Isolation still applies: one specialist pass = one package. The fingerprint script compares the two roots' contract paths even inside one git repo.
