#!/usr/bin/env bash
# Auditoria best-effort — NUNCA bloqueia (observacional).
set -uo pipefail
PHASE="${1:-TOOL}"
INPUT=$(cat)
DIR="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
LOG="$DIR/.claude/audit.log"
TOOL="?"; TGT="?"
if command -v jq >/dev/null 2>&1; then
  TOOL=$(jq -r '.tool_name // empty' <<<"$INPUT" 2>/dev/null || echo "?")
  TGT=$(jq -r '.tool_input.file_path // .tool_input.command // empty' <<<"$INPUT" 2>/dev/null | head -c 200)
fi
printf '[%s] %s | tool=%s | target=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$PHASE" "$TOOL" "$TGT" >> "$LOG" 2>/dev/null || true
exit 0
