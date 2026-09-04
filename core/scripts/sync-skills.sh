#!/usr/bin/env bash
# Re-copy core skills from this kit into client + server so copies stay identical.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE="$(cd "$SCRIPT_DIR/.." && pwd)"

CONFIG="${SITCH_CONFIG:-./sitch.yaml}"
CLIENT_ROOT="${SITCH_CLIENT_ROOT:-}"
SERVER_ROOT="${SITCH_SERVER_ROOT:-}"

if [[ -f "$CONFIG" ]]; then
  in_client=0
  in_server=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%$'\r'}"
    if [[ "$line" =~ ^client: ]]; then in_client=1; in_server=0; continue; fi
    if [[ "$line" =~ ^server: ]]; then in_server=1; in_client=0; continue; fi
    if [[ "$line" =~ ^[a-zA-Z_] ]]; then in_client=0; in_server=0; fi
    if [[ $in_client -eq 1 && "$line" =~ ^[[:space:]]+root:[[:space:]]*(.+)$ ]]; then
      CLIENT_ROOT="${BASH_REMATCH[1]}"
      CLIENT_ROOT="${CLIENT_ROOT%$'\r'}"
    fi
    if [[ $in_server -eq 1 && "$line" =~ ^[[:space:]]+root:[[:space:]]*(.+)$ ]]; then
      SERVER_ROOT="${BASH_REMATCH[1]}"
      SERVER_ROOT="${SERVER_ROOT%$'\r'}"
    fi
  done < "$CONFIG"
  CONFIG_DIR="$(cd "$(dirname "$CONFIG")" && pwd)"
  if [[ "$CLIENT_ROOT" != /* ]]; then CLIENT_ROOT="$CONFIG_DIR/$CLIENT_ROOT"; fi
  if [[ "$SERVER_ROOT" != /* ]]; then SERVER_ROOT="$CONFIG_DIR/$SERVER_ROOT"; fi
fi

CLIENT_ROOT="${1:-$CLIENT_ROOT}"
SERVER_ROOT="${2:-$SERVER_ROOT}"

if [[ -z "$CLIENT_ROOT" || -z "$SERVER_ROOT" ]]; then
  echo "Usage: sync-skills.sh [client-root] [server-root]"
  echo "Or set sitch.yaml / SITCH_CLIENT_ROOT / SITCH_SERVER_ROOT"
  exit 1
fi

sync_one() {
  local dest_root="$1"
  mkdir -p "$dest_root/.cursor/skills" "$dest_root/.claude/skills" "$dest_root/.cursor/rules"
  for skill in sitch-orchestrator sitch-client sitch-server fingerprint-check pre-ship-check; do
    rm -rf "$dest_root/.cursor/skills/$skill" "$dest_root/.claude/skills/$skill"
    cp -R "$CORE/skills/$skill" "$dest_root/.cursor/skills/$skill"
    cp -R "$CORE/skills/$skill" "$dest_root/.claude/skills/$skill"
  done
  cp "$CORE/rules/isolation.mdc" "$dest_root/.cursor/rules/sitch-isolation.mdc"
  echo "synced → $dest_root"
}

sync_one "$CLIENT_ROOT"
sync_one "$SERVER_ROOT"
echo "Done. Skills are byte-copied from $CORE/skills"
