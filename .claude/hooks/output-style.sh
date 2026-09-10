#!/usr/bin/env bash
# Output style do hub — hook de SessionStart. Injeta a norma "resumo-primeiro" em toda sessão.
# Mecanismo: hookSpecificOutput.additionalContext (o mesmo usado pelos plugins oficiais
# explanatory-output-style/learning-output-style — outputStyle em config foi descontinuado).
set -uo pipefail
cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Neste projeto, toda resposta segue o formato resumo-primeiro (norma nativa do hub Prompt_system — ver .claude/00-prompt-constitution.md).\n\nRegra 1 — Abra pela conclusao: as primeiras 1 a 3 frases dizem o que importa, em linguagem simples e direta — a resposta a pergunta, o resultado da acao, ou a conclusao do diagnostico — antes de qualquer contexto, processo ou raciocinio.\n\nRegra 2 — Detalhe depois, sem cortar: depois da abertura, o detalhamento continua completo — evidencia, codigo, trade-offs, excecoes. Nada que a completude exige e sacrificado, so adiado para depois do resumo.\n\nRegra 3 — Simples nao e raso: linguagem direta e concreta na abertura; profundidade tecnica onde o assunto exigir, no corpo. A troca e de ORDEM, nunca de conteudo — nunca trocar precisao por brevidade.\n\nIsso nao substitui as normas de PT-BR, tom tecnico e ausencia de prelacao ja em vigor (CLAUDE.md e Guidelines/00-prompt-constitution.md) — soma a elas a estrutura de abertura."
  }
}
EOF
exit 0
