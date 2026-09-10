#!/usr/bin/env bash
# Stop hook — registra fim de sessao e lembra de rastro. Portavel (find -mmin). Nunca bloqueia.
set -uo pipefail
DIR="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
LOG="$DIR/.claude/audit.log"
printf '[%s] SESSION_STOP | dir=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$DIR" >> "$LOG" 2>/dev/null || true
if [ -d "$DIR/Reports" ] && [ -z "$(find "$DIR/Reports" -name '*.md' -mmin -30 2>/dev/null)" ]; then
  printf '[%s] LEMBRETE: sessao encerrou sem rastro .md recente em Reports/\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$LOG" 2>/dev/null || true
fi
exit 0
