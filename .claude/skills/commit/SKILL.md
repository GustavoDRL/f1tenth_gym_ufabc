---
name: commit
description: Commit com mensagem semântica no padrão Conventional Commits, em PT-BR.
argument-hint: "[mensagem opcional]"
allowed-tools: Bash(git *)
model: sonnet
effort: medium
---

Analise as mudanças staged (ou todas as mudanças, se nada estiver staged) e realize um commit seguindo o padrão **Conventional Commits** em PT-BR.

## Processo

### 1. Inspecionar o estado do repositório

Execute em paralelo:
- `git status` — identifica arquivos modificados, novos e deletados
- `git diff --staged` — mostra exatamente o que está staged
- `git log --oneline -5` — entende o estilo de mensagens já usadas no projeto

Se `git diff --staged` estiver vazio, execute `git diff` para ver as mudanças não staged e pergunte ao usuário quais arquivos devem ser incluídos no commit antes de continuar.

### 2. Classificar a mudança

Determine o **tipo** com base no diff:

| Tipo | Quando usar |
|------|-------------|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `docs` | Apenas documentação |
| `style` | Formatação sem mudança de lógica |
| `refactor` | Reestruturação sem bug fix nem feature |
| `perf` | Melhoria de performance |
| `test` | Adição ou correção de testes |
| `build` | Sistema de build ou dependências |
| `ci` | Configuração de CI/CD |
| `chore` | Manutenção geral |
| `revert` | Reverte commit anterior |

Se a mudança se enquadra em mais de um tipo, sugira dividir em commits separados, mas permita que o usuário decida.

### 3. Identificar o escopo (opcional)

O escopo é um substantivo curto que indica a área afetada: `api`, `auth`, `db`, `ui`, `config`, `parser`, nome do módulo/serviço, etc. Omita se a mudança for transversal.

### 4. Redigir a mensagem

**Formato obrigatório:**
```
<tipo>[escopo opcional]: <descrição>

[corpo opcional]

[rodapé(s) opcional(is)]
```

**Regras para a descrição:**
- Verbo no **imperativo**: "adiciona", "corrige", "remove", "atualiza", "refatora"
- **Sem** letra maiúscula no início
- **Sem** ponto final
- Máximo de 72 caracteres

**Quando incluir corpo:**
- A mudança precisa de contexto sobre o *porquê*, não apenas o *o quê*
- Há decisão de design relevante ou comportamento não óbvio
- Corpo separado da descrição por uma linha em branco

**Breaking changes:**
- Com `!` após tipo/escopo: `feat(api)!: remove endpoint legado`
- Ou com rodapé: `BREAKING CHANGE: descrição do que quebrou`

**Exemplos do padrão esperado neste projeto:**
```
docs: adiciona documentacao completa sobre Claude Code Agents
feat(auth): adiciona autenticacao via OAuth2
fix(api): corrige timeout em requisicoes longas
refactor(db): separa logica de conexao em modulo proprio
```

### 5. Apresentar e confirmar

Exiba a mensagem proposta e aguarde aprovação do usuário. Se o usuário sugerir ajustes, aplique-os antes de commitar.

### 6. Executar o commit

Após aprovação, stage os arquivos relevantes (se ainda não estiverem staged) e execute o commit usando HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
<tipo>[escopo]: <descrição>

[corpo]

[rodapé]
EOF
)"
```

Confirme o sucesso com `git log --oneline -1`.

## Regras invioláveis

- Nunca use `--no-verify`
- Nunca faça `--amend` em commits já enviados ao remoto
- Nunca inclua arquivos com segredos (`.env`, credenciais, tokens)
- Commits devem ser atômicos — uma única mudança lógica por commit
- Se houver mudanças não relacionadas staged, avise o usuário e sugira separação
