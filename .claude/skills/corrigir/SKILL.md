---
name: corrigir
description: Aciona o corretor para corrigir o código de produção a partir dos achados do /test, no loop teste↔correção. Use após o /test reportar falhas.
argument-hint: "[caminho do relatório do /test ou descrição dos achados]"
allowed-tools: Read Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **corretor** com o alvo `$ARGUMENTS` (o relatório de achados do `/test`).

Contexto fino (não duplica o system prompt do subagente):
- O corretor **consome o relatório do `/test`**, investiga cada achado, corrige **apenas o código de produção** e devolve ao `/test` para revalidar — no loop teste↔correção. **Não roda a suíte** (lane do `/test`) nem edita arquivos de teste.
- Se um achado for **teste incorreto** (não bug de produção), o corretor devolve ao `/test` (não corrige testes).
- Aplique o **GATE padronizado**: aprovar o plano de correção antes de editar; confirmação única antes do push da branch de fix.
- Gere o **RASTRO .md** ao final, conforme o subagente.
- Depois da revalidação verde no `/test`, o ciclo segue para `/pr` (abre o PR sobre a branch já no remote) → `/review`.
