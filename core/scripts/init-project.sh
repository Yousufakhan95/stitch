#!/usr/bin/env bash
# Initialize a client + server project with Sitch core templates and skills.
set -euo pipefail

CLIENT="${1:?Usage: init-project.sh <client-root> <server-root>}"
SERVER="${2:?Usage: init-project.sh <client-root> <server-root>}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE="$(cd "$SCRIPT_DIR/.." && pwd)"
KIT="$(cd "$CORE/.." && pwd)"

copy_skills() {
  local dest_root="$1"
  mkdir -p "$dest_root/.cursor/skills" "$dest_root/.claude/skills" "$dest_root/.cursor/rules"
  for skill in sitch-orchestrator sitch-client sitch-server fingerprint-check pre-ship-check; do
    rm -rf "$dest_root/.cursor/skills/$skill" "$dest_root/.claude/skills/$skill"
    cp -R "$CORE/skills/$skill" "$dest_root/.cursor/skills/$skill"
    cp -R "$CORE/skills/$skill" "$dest_root/.claude/skills/$skill"
  done
  cp "$CORE/rules/isolation.mdc" "$dest_root/.cursor/rules/sitch-isolation.mdc"
}

scaffold_side() {
  local root="$1"
  mkdir -p "$root/docs/contracts"
  if [[ ! -f "$root/docs/STITCH_LEDGER.md" ]]; then
    cp "$CORE/templates/STITCH_LEDGER.md" "$root/docs/STITCH_LEDGER.md"
  fi
  if [[ ! -f "$root/docs/api-structure.md" ]]; then
    cp "$CORE/templates/api-structure.stub.md" "$root/docs/api-structure.md"
  fi
  copy_skills "$root"
}

scaffold_side "$CLIENT"
scaffold_side "$SERVER"

# workspace config next to both (parent of client if siblings, else cwd)
CONFIG_DIR="$(pwd)"
cat > "$CONFIG_DIR/sitch.yaml" <<EOF
version: 1

client:
  root: $(cd "$CLIENT" && pwd)
  ledger: docs/STITCH_LEDGER.md
  contracts_dir: docs/contracts
  api_structure: docs/api-structure.md

server:
  root: $(cd "$SERVER" && pwd)
  ledger: docs/STITCH_LEDGER.md
  contracts_dir: docs/contracts
  api_structure: docs/api-structure.md

path_classes:
  - id: default
    description: Standard request/response on the server process

defaults:
  server_first: true
  require_tests: true
  require_fingerprint_at_phase_boundary: true
EOF

mkdir -p "$CONFIG_DIR/scripts"
cp "$CORE/skills/fingerprint-check/scripts/check-fingerprint.sh" "$CONFIG_DIR/scripts/check-fingerprint.sh"
chmod +x "$CONFIG_DIR/scripts/check-fingerprint.sh" \
  "$CORE/skills/fingerprint-check/scripts/check-fingerprint.sh" \
  "$SCRIPT_DIR/init-project.sh" \
  "$SCRIPT_DIR/sync-skills.sh" 2>/dev/null || true

echo "Sitch initialized."
echo "  client: $CLIENT"
echo "  server: $SERVER"
echo "  config: $CONFIG_DIR/sitch.yaml"
echo "Copy skills are in .cursor/skills and .claude/skills on both sides."
echo "Kit reference: $KIT"
