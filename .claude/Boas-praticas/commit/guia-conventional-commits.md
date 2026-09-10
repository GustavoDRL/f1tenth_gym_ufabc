# Guia Completo de Conventional Commits

## Sumario

- [Por que padronizar commits?](#por-que-padronizar-commits)
- [Estrutura da mensagem](#estrutura-da-mensagem)
- [Tipos de commit](#tipos-de-commit)
- [Escopo](#escopo)
- [Descricao](#descricao)
- [Corpo](#corpo)
- [Rodape](#rodape)
- [Breaking Changes](#breaking-changes)
- [Relacao com Versionamento Semantico (SemVer)](#relacao-com-versionamento-semantico-semver)
- [Exemplos praticos](#exemplos-praticos)
- [Regras formais da especificacao](#regras-formais-da-especificacao)
- [Boas praticas no dia a dia](#boas-praticas-no-dia-a-dia)
- [Perguntas frequentes](#perguntas-frequentes)
- [Ferramentas uteis](#ferramentas-uteis)

---

## Por que padronizar commits?

Mensagens de commit padronizadas trazem beneficios concretos:

- **CHANGELOG automatico** — ferramentas geram o historico de mudancas a partir dos commits
- **Versionamento automatico** — o tipo do commit determina se a proxima versao sera patch, minor ou major
- **Comunicacao clara** — qualquer pessoa entende a natureza da mudanca sem ler o diff
- **Historico navegavel** — facilita buscar quando e por que algo foi alterado
- **CI/CD inteligente** — pipelines podem reagir de forma diferente a `fix`, `feat` ou `breaking change`
- **Contribuicao facilitada** — novos colaboradores entendem o padrao rapidamente

---

## Estrutura da mensagem

Todo commit segue esta estrutura:

```
<tipo>[escopo opcional]: <descricao>

[corpo opcional]

[rodape(s) opcional(is)]
```

Somente o **tipo** e a **descricao** sao obrigatorios. O restante e opcional, mas recomendado para mudancas significativas.

### Anatomia visual

```
feat(auth): adiciona autenticacao via OAuth2 com Google
│    │       │
│    │       └─ descricao: resumo breve e direto da mudanca
│    │
│    └─ escopo: area do codigo afetada
│
└─ tipo: categoria da mudanca
```

---

## Tipos de commit

### Tipos principais

| Tipo   | Quando usar                                      | SemVer    |
|--------|--------------------------------------------------|-----------|
| `feat` | Adiciona uma funcionalidade **nova**              | **MINOR** |
| `fix`  | Corrige um **bug** existente                      | **PATCH** |

### Tipos complementares

| Tipo       | Quando usar                                                            |
|------------|------------------------------------------------------------------------|
| `docs`     | Alteracoes apenas em documentacao                                      |
| `style`    | Formatacao, ponto e virgula, espacos — **sem alteracao de logica**      |
| `refactor` | Reestruturacao de codigo que nao corrige bug nem adiciona feature       |
| `perf`     | Melhoria de performance                                                |
| `test`     | Adiciona ou corrige testes                                             |
| `build`    | Alteracoes no sistema de build ou dependencias externas (npm, pip, etc)|
| `ci`       | Alteracoes em arquivos e scripts de CI/CD                              |
| `chore`    | Tarefas de manutencao que nao alteram codigo de producao nem testes     |
| `revert`   | Reverte um commit anterior                                             |

> **Regra:** `feat` e `fix` sao obrigatorios pela especificacao. Os demais tipos sao amplamente adotados pela comunidade e recomendados.

---

## Escopo

O escopo e um **substantivo entre parenteses** logo apos o tipo. Ele descreve a secao do codigo afetada.

```
feat(parser): adiciona suporte a arrays aninhados
fix(api): corrige timeout em requisicoes longas
docs(readme): atualiza instrucoes de instalacao
refactor(auth): separa logica de token em modulo proprio
```

### Boas praticas para escopo

- Use nomes **curtos e consistentes** ao longo do projeto
- Represente modulos, componentes ou camadas: `api`, `auth`, `db`, `ui`, `parser`, `config`
- Defina uma lista de escopos aceitos com a equipe para manter consistencia
- O escopo e **opcional** — omita quando a mudanca e transversal

---

## Descricao

A descricao vem logo apos o tipo (e escopo, se houver), separada por `: `.

### Regras

- Use o **imperativo**: "adiciona", "corrige", "remove" (nao "adicionado" ou "adicionando")
- **Nao** comece com letra maiuscula
- **Nao** termine com ponto final
- Seja breve e direto — idealmente ate 72 caracteres

```
# Bom
feat(cart): adiciona calculo de frete por CEP

# Ruim
feat(cart): Adicionado o calculo de frete baseado no CEP do usuario.
```

---

## Corpo

O corpo fornece **contexto adicional** sobre a mudanca. Ele e separado da descricao por uma linha em branco.

```
fix(auth): corrige loop infinito ao renovar token expirado

O token era renovado mesmo quando a sessao ja havia sido invalidada
no servidor, causando um ciclo infinito de requisicoes 401 seguidas
de tentativas de refresh.

A correcao verifica o status da sessao antes de tentar renovar.
```

### Quando usar o corpo

- A mudanca precisa de explicacao sobre o **por que**, nao apenas o **o que**
- Ha contexto tecnico relevante que nao cabe na descricao
- A mudanca e grande ou envolve decisoes de design

---

## Rodape

Os rodapes vem apos o corpo (separados por linha em branco) e seguem o formato:

```
<token>: <valor>
```

ou, para referencias com `#`:

```
<token> #<valor>
```

### Exemplos de rodape

```
Refs #133
Reviewed-by: Maria Silva
Co-authored-by: Joao <joao@email.com>
Closes #45
BREAKING CHANGE: o campo `name` foi renomeado para `full_name`
```

### Regras para tokens de rodape

- Use `-` (hifen) no lugar de espacos no token (ex: `Reviewed-by`, `Co-authored-by`)
- Excecao: `BREAKING CHANGE` usa espaco e **deve** ser em maiusculas
- `BREAKING-CHANGE` (com hifen) funciona como sinonimo

---

## Breaking Changes

Uma **breaking change** e qualquer mudanca que quebra a compatibilidade com a versao anterior. Pode ser indicada de **duas formas**:

### Forma 1 — No rodape

```
feat(api): altera formato de resposta do endpoint /users

BREAKING CHANGE: o campo `name` foi dividido em `first_name` e `last_name`
```

### Forma 2 — Com `!` apos o tipo/escopo

```
feat(api)!: altera formato de resposta do endpoint /users
```

### Combinando ambas

```
feat(api)!: altera formato de resposta do endpoint /users

BREAKING CHANGE: o campo `name` foi dividido em `first_name` e `last_name`
```

> Breaking changes podem ocorrer em **qualquer tipo** de commit, nao apenas em `feat` ou `fix`:
> ```
> chore!: remove suporte para Node 14
> refactor!: renomeia todas as interfaces publicas
> ```

---

## Relacao com Versionamento Semantico (SemVer)

O Conventional Commits foi projetado para alimentar o [SemVer](https://semver.org) (`MAJOR.MINOR.PATCH`):

| Situacao                                   | Versao impactada | Exemplo        |
|--------------------------------------------|------------------|----------------|
| Commit do tipo `fix`                       | **PATCH** (x.x.X)| 1.0.0 → 1.0.1 |
| Commit do tipo `feat`                      | **MINOR** (x.X.x)| 1.0.1 → 1.1.0 |
| Qualquer commit com `BREAKING CHANGE` ou `!`| **MAJOR** (X.x.x)| 1.1.0 → 2.0.0 |

### Fluxo visual

```
fix(parser): corrige parse de datas       →  v1.2.3 → v1.2.4  (PATCH)
feat(auth): adiciona login biometrico     →  v1.2.4 → v1.3.0  (MINOR)
feat(api)!: remove endpoint legado        →  v1.3.0 → v2.0.0  (MAJOR)
```

---

## Exemplos praticos

### Commit simples — apenas descricao

```
docs: corrige erro ortografico no CHANGELOG
```

### Commit com escopo

```
feat(lang): adiciona traducao para portugues brasileiro
```

### Commit com corpo e rodape

```
fix: corrige pequenos erros de digitacao no codigo

Veja o ticket para detalhes sobre os erros de digitacao corrigidos.

Reviewed-by: Daniel Nass
Refs #133
```

### Commit com breaking change no rodape

```
feat: permite que o objeto de configuracao estenda outras configuracoes

BREAKING CHANGE: a chave `extends` no arquivo de configuracao agora e
utilizada para estender outro arquivo de configuracao
```

### Commit com `!` indicando breaking change

```
feat!: envia email para o cliente quando o produto e enviado
```

### Commit com escopo e `!`

```
feat(api)!: envia email para o cliente quando o produto e enviado
```

### Commit com `!` e rodape BREAKING CHANGE

```
chore!: remove suporte para Node 6

BREAKING CHANGE: refatorar para usar recursos do JavaScript nao disponiveis no Node 6.
```

### Commit de revert

```
revert: nunca mais falaremos do incidente do miojo

Refs: 676104e, a215868
```

---

## Regras formais da especificacao

As 16 regras oficiais do Conventional Commits v1.0.0:

1. Todo commit **deve** ser prefixado com um tipo (substantivo como `feat` ou `fix`), seguido de escopo opcional, `!` opcional, e finalizado com dois pontos e espaco.

2. O tipo `feat` **deve** ser usado quando o commit adiciona uma nova funcionalidade.

3. O tipo `fix` **deve** ser usado quando o commit corrige um problema.

4. Um escopo **pode** ser fornecido apos o tipo. O escopo **deve** ser um substantivo entre parenteses descrevendo a secao do codigo (ex: `fix(parser):`).

5. A descricao **deve** existir logo apos o espaco que segue o tipo/escopo. E um resumo breve da mudanca.

6. Um corpo mais longo **pode** ser fornecido apos a descricao curta, separado por uma linha em branco.

7. O corpo e livre e **pode** consistir de quantos paragrafos forem necessarios, separados por linhas em branco.

8. Um ou mais rodapes **podem** ser fornecidos apos o corpo, separados por uma linha em branco. Cada rodape consiste de um token, um separador (`: ` ou ` #`), e um valor.

9. O token do rodape **deve** usar `-` no lugar de espacos (ex: `Acked-by`). Excecao: `BREAKING CHANGE`.

10. O valor do rodape **pode** conter espacos e quebras de linha. A leitura termina quando o proximo par token/separador valido e encontrado.

11. Breaking changes **devem** ser indicadas no prefixo tipo/escopo ou como entrada no rodape.

12. Como rodape, breaking change **deve** consistir do texto em maiusculas `BREAKING CHANGE`, seguido de dois pontos, espaco e descricao.

13. Como prefixo, breaking change **deve** ser indicada por `!` imediatamente antes de `:`. Se `!` for usado, `BREAKING CHANGE:` no rodape **pode** ser omitido, e a descricao do commit **deve** descrever a mudanca.

14. Tipos diferentes de `feat` e `fix` **podem** ser usados nas mensagens de commit.

15. As unidades de informacao do Conventional Commits **nao devem** ser tratadas com distincao de maiusculas/minusculas, exceto `BREAKING CHANGE` que **deve** ser em maiusculas.

16. `BREAKING-CHANGE` **deve** ser sinonimo de `BREAKING CHANGE` quando usado como token de rodape.

---

## Boas praticas no dia a dia

### Commits atomicos

Cada commit deve representar **uma unica mudanca logica**. Se voce fez duas coisas diferentes, faca dois commits.

```bash
# Ruim — mistura correção com feature
git commit -m "fix(api): corrige timeout e adiciona endpoint de relatorios"

# Bom — separado em dois commits
git commit -m "fix(api): corrige timeout em requisicoes longas"
git commit -m "feat(api): adiciona endpoint de relatorios mensais"
```

### Staging seletivo

Use `git add -p` ou `git add <arquivo>` para commitar apenas os arquivos relevantes a uma mudanca:

```bash
# Adiciona apenas os arquivos relacionados ao fix
git add src/api/timeout.js src/api/timeout.test.js
git commit -m "fix(api): corrige timeout em requisicoes longas"

# Depois adiciona os do feat
git add src/api/reports.js src/api/reports.test.js
git commit -m "feat(api): adiciona endpoint de relatorios mensais"
```

### Frequencia

- Commite **cedo e com frequencia** — commits pequenos sao mais faceis de revisar e reverter
- Nao acumule um dia inteiro de trabalho em um unico commit

### Revisao antes de commitar

```bash
# Veja o que mudou antes de commitar
git diff --staged

# Revise e faca o commit com confianca
git commit -m "feat(auth): adiciona validacao de token JWT"
```

### Reescrevendo commits (antes de push)

Se cometeu um erro na mensagem:

```bash
# Corrige o ultimo commit (antes de dar push)
git commit --amend -m "fix(auth): corrige validacao de token expirado"

# Para reorganizar varios commits locais
git rebase -i HEAD~3
```

> **Atencao:** nunca faca `--amend` ou `rebase` em commits que ja foram enviados para o remoto compartilhado.

### Template de commit

Configure um template para lembrar do formato:

```bash
git config --global commit.template ~/.gitmessage
```

Conteudo de `~/.gitmessage`:

```
# <tipo>[escopo]: <descricao>
#
# [corpo]
#
# [rodape]
#
# Tipos: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
# Escopo: area do codigo (auth, api, ui, db, config...)
# Descricao: imperativo, sem ponto final, ate 72 caracteres
```

---

## Perguntas frequentes

### Como lidar com commits na fase inicial do desenvolvimento?

Proceda como se o produto ja estivesse em producao. Outras pessoas (ou voce no futuro) precisam saber o que sao fixes, features e breaking changes.

### Os tipos devem ser em maiusculas ou minusculas?

Tanto faz, mas **seja consistente**. O padrao mais comum e tudo em minusculas.

### E se meu commit se encaixa em mais de um tipo?

Sempre que possivel, **divida em multiplos commits**. O beneficio do padrao esta justamente em commits organizados e focados.

### Conventional Commits atrapalha o desenvolvimento rapido?

Nao. Ele desencoraja a movimentacao rapida **de forma desorganizada**. A longo prazo, permite mover-se com mais velocidade em projetos com multiplos colaboradores.

### E se eu usei o tipo errado?

- **Antes do merge/release:** use `git rebase -i` para editar o historico
- **Tipo que nao existe na especificacao:** nao e catastrofico — ferramentas baseadas na especificacao simplesmente ignoram

### Todos os colaboradores precisam seguir o padrao?

Nao necessariamente. Em fluxos de trabalho baseados em **squash merge**, o mantenedor pode reescrever a mensagem final durante o merge, sem sobrecarregar colaboradores ocasionais.

### Como lidar com commits de revert?

A especificacao nao impoe um comportamento. A recomendacao e usar o tipo `revert` com rodape referenciando os SHAs dos commits revertidos:

```
revert: reverte mudanca no calculo de frete

Refs: 676104e, a215868
```

---

## Ferramentas uteis

| Ferramenta | Descricao |
|---|---|
| [commitlint](https://commitlint.js.org/) | Valida mensagens de commit contra o padrao |
| [husky](https://typicode.github.io/husky/) | Git hooks para rodar commitlint automaticamente |
| [commitizen](https://commitizen-tools.github.io/commitizen/) | CLI interativo que guia a escrita do commit |
| [standard-version](https://github.com/conventional-changelog/standard-version) | Gera CHANGELOG e bump de versao automaticamente |
| [semantic-release](https://semantic-release.gitbook.io/) | Automacao completa de release baseada nos commits |
| [cz-cli](https://github.com/commitizen/cz-cli) | Adaptador commitizen para linha de comando |

### Exemplo com commitizen

```bash
# Instala globalmente
npm install -g commitizen cz-conventional-changelog

# Configura no projeto
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc

# Usa no lugar de git commit
git cz
```

O CLI apresenta um menu interativo:

```
? Select the type of change that you're committing:
  feat:     A new feature
  fix:      A bug fix
  docs:     Documentation only changes
  style:    Changes that do not affect the meaning of the code
  refactor: A code change that neither fixes a bug nor adds a feature
  ...
```

---

## Referencia rapida

```
feat(escopo): adiciona nova funcionalidade         → MINOR
fix(escopo): corrige bug                           → PATCH
docs(escopo): altera documentacao                  → -
style(escopo): formatacao sem mudanca de logica     → -
refactor(escopo): reestrutura sem mudar comportamento → -
perf(escopo): melhora performance                  → -
test(escopo): adiciona ou corrige testes           → -
build(escopo): altera build ou dependencias         → -
ci(escopo): altera configuracao de CI              → -
chore(escopo): manutencao geral                    → -
revert(escopo): reverte commit anterior            → -

<qualquer tipo>!: breaking change                  → MAJOR
```

---

> **Fonte:** [Conventional Commits v1.0.0](https://www.conventionalcommits.org/pt-br/v1.0.0/) — Licenca CC BY 3.0
