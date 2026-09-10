#!/usr/bin/env bash
# Guarda de Edit/Write — bloqueia edicao de segredos e dos proprios guarda-corpos. Fail-closed.
set -uo pipefail
shopt -s nocasematch   # FS do macOS e' case-insensitive: .ENV deve casar .env
INPUT=$(cat)
command -v jq >/dev/null 2>&1 || { echo "BLOQUEADO: jq ausente." >&2; exit 2; }
FILE=$(jq -r '.tool_input.file_path // empty' <<<"$INPUT" 2>/dev/null) || { echo "BLOQUEADO: input invalido." >&2; exit 2; }
[ -z "$FILE" ] && exit 0
BASE=$(basename "$FILE")
case "$BASE" in
  .env|.env.*|*.pem|*.key|id_rsa|id_rsa.*|*credentials*|secrets.*|.npmrc|.pypirc)
    echo "BLOQUEADO: nao e permitido modificar arquivo de segredos: $FILE" >&2; exit 2 ;;
esac
# Guarda-corpos/config — cobre caminho absoluto E relativo (sem barra inicial).
case "$FILE" in
  *.git/hooks/*|.git/hooks/*|*.git/config|.git/config|*/.claude/settings.json|.claude/settings.json|*/.claude/settings.local.json|.claude/settings.local.json|*/.claude/hooks/*|.claude/hooks/*|*/.claude/audit.log|.claude/audit.log)
    echo "BLOQUEADO: nao e permitido modificar guarda-corpos/config/audit: $FILE" >&2; exit 2 ;;
esac
# SSH e rc-files: escrita aqui envenena a sessao seguinte (ex.: export CLAUDE_CONFIRM_REMOTE=1).
case "$FILE" in
  */.ssh/*|.ssh/*|*/.zshrc|*/.bashrc|*/.bash_profile|*/.profile|*/.zprofile)
    echo "BLOQUEADO: nao e permitido modificar SSH/rc-files (envenenamento de sessao): $FILE" >&2; exit 2 ;;
esac
exit 0
