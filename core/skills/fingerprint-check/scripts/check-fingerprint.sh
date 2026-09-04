#!/usr/bin/env bash
# Compares SHA-256 of a canonical contract file between Stitch client and server.
# See ../SKILL.md for usage.
set -euo pipefail

ARG="${1:?Usage: check-fingerprint.sh <contract-filename-or-relative-path>}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional stitch.yaml next to cwd or via STITCH_CONFIG
CONFIG="${STITCH_CONFIG:-}"
if [[ -z "$CONFIG" && -f "./stitch.yaml" ]]; then
  CONFIG="./stitch.yaml"
fi

CLIENT_ROOT="${STITCH_CLIENT_ROOT:-}"
SERVER_ROOT="${STITCH_SERVER_ROOT:-}"
CLIENT_CONTRACTS="docs/contracts"
SERVER_CONTRACTS="docs/contracts"

if [[ -n "$CONFIG" && -f "$CONFIG" ]]; then
  # minimal parse: root: and contracts_dir: under client:/server: blocks
  in_client=0
  in_server=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%$'\r'}"
    if [[ "$line" =~ ^client: ]]; then in_client=1; in_server=0; continue; fi
    if [[ "$line" =~ ^server: ]]; then in_server=1; in_client=0; continue; fi
    if [[ "$line" =~ ^[a-zA-Z_] ]]; then in_client=0; in_server=0; fi
    if [[ $in_client -eq 1 && "$line" =~ ^[[:space:]]+root:[[:space:]]*(.+)$ ]]; then
      val="${BASH_REMATCH[1]}"
      val="${val%$'\r'}"
      CLIENT_ROOT="${CLIENT_ROOT:-$val}"
    fi
    if [[ $in_server -eq 1 && "$line" =~ ^[[:space:]]+root:[[:space:]]*(.+)$ ]]; then
      val="${BASH_REMATCH[1]}"
      val="${val%$'\r'}"
      SERVER_ROOT="${SERVER_ROOT:-$val}"
    fi
    if [[ $in_client -eq 1 && "$line" =~ ^[[:space:]]+contracts_dir:[[:space:]]*(.+)$ ]]; then
      CLIENT_CONTRACTS="${BASH_REMATCH[1]}"
      CLIENT_CONTRACTS="${CLIENT_CONTRACTS%$'\r'}"
    fi
    if [[ $in_server -eq 1 && "$line" =~ ^[[:space:]]+contracts_dir:[[:space:]]*(.+)$ ]]; then
      SERVER_CONTRACTS="${BASH_REMATCH[1]}"
      SERVER_CONTRACTS="${SERVER_CONTRACTS%$'\r'}"
    fi
  done < "$CONFIG"
  CONFIG_DIR="$(cd "$(dirname "$CONFIG")" && pwd)"
  # resolve relative roots against config dir
  if [[ -n "$CLIENT_ROOT" && "$CLIENT_ROOT" != /* ]]; then
    CLIENT_ROOT="$CONFIG_DIR/$CLIENT_ROOT"
  fi
  if [[ -n "$SERVER_ROOT" && "$SERVER_ROOT" != /* ]]; then
    SERVER_ROOT="$CONFIG_DIR/$SERVER_ROOT"
  fi
fi

if [[ -z "$CLIENT_ROOT" || -z "$SERVER_ROOT" ]]; then
  echo "Set STITCH_CLIENT_ROOT and STITCH_SERVER_ROOT, or provide stitch.yaml with client.root / server.root"
  exit 1
fi

if [[ "$ARG" == */* ]]; then
  CLIENT_FILE="$CLIENT_ROOT/$ARG"
  SERVER_FILE="$SERVER_ROOT/$ARG"
else
  CLIENT_FILE="$CLIENT_ROOT/$CLIENT_CONTRACTS/$ARG"
  SERVER_FILE="$SERVER_ROOT/$SERVER_CONTRACTS/$ARG"
fi

missing=0
for f in "$CLIENT_FILE" "$SERVER_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "MISSING: $f"
    missing=1
  fi
done
if [[ "$missing" -eq 1 ]]; then
  exit 1
fi

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    echo "Need sha256sum or shasum" >&2
    exit 1
  fi
}

CLIENT_HASH="$(hash_file "$CLIENT_FILE")"
SERVER_HASH="$(hash_file "$SERVER_FILE")"
NOW="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo "client: $CLIENT_HASH  ($CLIENT_FILE)"
echo "server: $SERVER_HASH  ($SERVER_FILE)"
echo

if [[ "$CLIENT_HASH" == "$SERVER_HASH" ]]; then
  echo "MATCH — paste into both STITCH_LEDGER.md rows:"
  echo "contract_fingerprint: $CLIENT_HASH"
  echo "contract_checked_at: $NOW"
  echo "wire_deviations: none"
  exit 0
else
  echo "MISMATCH — do not mark phase_contract_verified. Diff the files and amend the contract before either side proceeds."
  exit 2
fi
