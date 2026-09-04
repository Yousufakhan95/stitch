#!/usr/bin/env bash
# Stitch gate — enforceable checks from stitch.yaml (not prose-only).
#
# Usage:
#   gate.sh [--contract <file>] [--skip-ledger-tests]
#
# Always runs fingerprint when --contract is given (or hello-v1.md if present
# under examples; otherwise requires --contract).
#
# When defaults.require_tests is true (default), also scans ledger files on
# each side and fails if progressed slices lack test-evidence fields.
#
# Exit codes:
#   0  all checks passed
#   1  usage / missing config or files
#   2  fingerprint MISMATCH (or fingerprint script missing)
#   3  require_tests violated (empty ledger test fields)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE="$(cd "$SCRIPT_DIR/.." && pwd)"
FINGERPRINT="$CORE/skills/fingerprint-check/scripts/check-fingerprint.sh"

CONTRACT=""
SKIP_LEDGER_TESTS=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --contract)
      CONTRACT="${2:?}"
      shift 2
      ;;
    --skip-ledger-tests)
      SKIP_LEDGER_TESTS=1
      shift
      ;;
    -h|--help)
      sed -n '2,20p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 1
      ;;
  esac
done

CONFIG="${STITCH_CONFIG:-}"
if [[ -z "$CONFIG" && -f "./stitch.yaml" ]]; then
  CONFIG="./stitch.yaml"
fi

CLIENT_ROOT="${STITCH_CLIENT_ROOT:-}"
SERVER_ROOT="${STITCH_SERVER_ROOT:-}"
CLIENT_LEDGER="docs/STITCH_LEDGER.md"
SERVER_LEDGER="docs/STITCH_LEDGER.md"
REQUIRE_TESTS=1

if [[ -n "$CONFIG" && -f "$CONFIG" ]]; then
  in_client=0
  in_server=0
  in_defaults=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%$'\r'}"
    if [[ "$line" =~ ^client: ]]; then in_client=1; in_server=0; in_defaults=0; continue; fi
    if [[ "$line" =~ ^server: ]]; then in_server=1; in_client=0; in_defaults=0; continue; fi
    if [[ "$line" =~ ^defaults: ]]; then in_defaults=1; in_client=0; in_server=0; continue; fi
    if [[ "$line" =~ ^[a-zA-Z_] ]]; then in_client=0; in_server=0; in_defaults=0; fi
    if [[ $in_client -eq 1 && "$line" =~ ^[[:space:]]+root:[[:space:]]*(.+)$ ]]; then
      val="${BASH_REMATCH[1]}"; val="${val%$'\r'}"
      CLIENT_ROOT="${CLIENT_ROOT:-$val}"
    fi
    if [[ $in_server -eq 1 && "$line" =~ ^[[:space:]]+root:[[:space:]]*(.+)$ ]]; then
      val="${BASH_REMATCH[1]}"; val="${val%$'\r'}"
      SERVER_ROOT="${SERVER_ROOT:-$val}"
    fi
    if [[ $in_client -eq 1 && "$line" =~ ^[[:space:]]+ledger:[[:space:]]*(.+)$ ]]; then
      CLIENT_LEDGER="${BASH_REMATCH[1]}"; CLIENT_LEDGER="${CLIENT_LEDGER%$'\r'}"
    fi
    if [[ $in_server -eq 1 && "$line" =~ ^[[:space:]]+ledger:[[:space:]]*(.+)$ ]]; then
      SERVER_LEDGER="${BASH_REMATCH[1]}"; SERVER_LEDGER="${SERVER_LEDGER%$'\r'}"
    fi
    if [[ $in_defaults -eq 1 && "$line" =~ ^[[:space:]]+require_tests:[[:space:]]*(.+)$ ]]; then
      val="$(echo "${BASH_REMATCH[1]}" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
      if [[ "$val" == "false" || "$val" == "0" || "$val" == "no" ]]; then
        REQUIRE_TESTS=0
      fi
    fi
  done < "$CONFIG"
  CONFIG_DIR="$(cd "$(dirname "$CONFIG")" && pwd)"
  if [[ -n "$CLIENT_ROOT" && "$CLIENT_ROOT" != /* ]]; then
    CLIENT_ROOT="$CONFIG_DIR/$CLIENT_ROOT"
  fi
  if [[ -n "$SERVER_ROOT" && "$SERVER_ROOT" != /* ]]; then
    SERVER_ROOT="$CONFIG_DIR/$SERVER_ROOT"
  fi
fi

if [[ -z "$CLIENT_ROOT" || -z "$SERVER_ROOT" ]]; then
  echo "Set STITCH_CLIENT_ROOT and STITCH_SERVER_ROOT, or provide stitch.yaml" >&2
  exit 1
fi

if [[ -z "$CONTRACT" ]]; then
  if [[ -f "$CLIENT_ROOT/docs/contracts/hello-v1.md" ]]; then
    CONTRACT="hello-v1.md"
  else
    echo "Pass --contract <file> (no default contract found)" >&2
    exit 1
  fi
fi

if [[ ! -x "$FINGERPRINT" ]]; then
  chmod +x "$FINGERPRINT" 2>/dev/null || true
fi
if [[ ! -f "$FINGERPRINT" ]]; then
  echo "Missing fingerprint script: $FINGERPRINT" >&2
  exit 2
fi

echo "== fingerprint: $CONTRACT =="
export STITCH_CLIENT_ROOT="$CLIENT_ROOT"
export STITCH_SERVER_ROOT="$SERVER_ROOT"
if [[ -n "$CONFIG" ]]; then
  export STITCH_CONFIG="$(cd "$(dirname "$CONFIG")" && pwd)/$(basename "$CONFIG")"
fi
set +e
"$FINGERPRINT" "$CONTRACT"
fp_rc=$?
set -e
if [[ $fp_rc -ne 0 ]]; then
  echo "gate: fingerprint failed (exit $fp_rc)" >&2
  exit 2
fi

# --- require_tests: ledger evidence ---
# Progressed slices must record non-empty test fields (command, n/a, or notes).
# This does not run the tests — it refuses empty self-reports when config requires tests.

ledger_gaps() {
  local ledger_path="$1"
  local side="$2" # client|server
  if [[ ! -f "$ledger_path" ]]; then
    echo "MISSING ledger: $ledger_path"
    return 0
  fi
  awk -v side="$side" '
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    /^## Slice:/ {
      if (name != "") check()
      name = $0
      sub(/^## Slice:[ \t]*/, "", name)
      status = ""
      server_tests = ""
      client_tests = ""
      next
    }
    /^status:/ {
      status = trim(substr($0, index($0, ":") + 1))
      next
    }
    /^server_tests:/ {
      server_tests = trim(substr($0, index($0, ":") + 1))
      next
    }
    /^client_tests:/ {
      client_tests = trim(substr($0, index($0, ":") + 1))
      next
    }
    END { if (name != "") check() }
    function check() {
      if (status == "" || status == "contracted" || status == "blocked") return
      need_server = (status ~ /^(server_done|client_done|slice_done|e2e_pass|phase_contract_verified)$/)
      need_client = (status ~ /^(client_done|slice_done|e2e_pass|phase_contract_verified)$/)
      if (side == "server" && need_server && server_tests == "") {
        printf "GAP %s ledger slice %s status=%s empty server_tests\n", side, name, status
      }
      if (side == "client" && need_client && client_tests == "") {
        printf "GAP %s ledger slice %s status=%s empty client_tests\n", side, name, status
      }
      # On each side file we also sanity-check the other field when fully done
      if (need_client && need_server) {
        if (side == "server" && client_tests == "") {
          # server ledger may leave client_tests for orchestrator — only require own field
        }
      }
    }
  ' "$ledger_path"
}

if [[ $SKIP_LEDGER_TESTS -eq 0 && $REQUIRE_TESTS -eq 1 ]]; then
  echo "== require_tests: ledger evidence =="
  gaps="$(ledger_gaps "$SERVER_ROOT/$SERVER_LEDGER" server; ledger_gaps "$CLIENT_ROOT/$CLIENT_LEDGER" client)"
  if [[ -n "$(echo "$gaps" | tr -d '[:space:]')" ]]; then
    echo "$gaps" >&2
    echo "gate: require_tests is true but ledger test fields are empty for progressed slices" >&2
    echo "      fill server_tests / client_tests (commands or n/a) or pass --skip-ledger-tests" >&2
    exit 3
  fi
  echo "ledger test fields: ok"
elif [[ $REQUIRE_TESTS -eq 0 ]]; then
  echo "== require_tests: false (skipped ledger evidence) =="
else
  echo "== ledger evidence: skipped =="
fi

echo "gate: PASS"
exit 0
