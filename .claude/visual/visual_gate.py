"""Gera as páginas HTML dos gates da trilha de planejamento profundo.

Fonte de verdade são os .md do workspace (docs/planos/<data>-<nome>/); o HTML
é DERIVADO — regenerável por comando, nunca editado à mão. Stdlib-only por
design: nos projetos-alvo roda como `python3 .claude/visual/visual_gate.py
<workspace> --gate N` (deploy.sh copia este arquivo + assets/ para lá).
Convenção de fontes por gate: spec 2026-08-31-planejamento-visual §6.2.
"""

from __future__ import annotations

import argparse
import html
import re
import shutil
import sys
from pathlib import Path

GATES = {
    1: ("gate-1-coleta.html", "Gate 1 — Coleta de specs", ["manifesto.md"]),
    2: ("gate-2-revisao.html", "Gate 2 — Revisão detetive", ["revisao.md"]),
    3: ("gate-3-plano.html", "Gate 3 — Sala de aprovação do plano", ["plano.md"]),
}

_RX_LINK_MD = re.compile(r"\[[^\]]*\]\(([^)#][^)]*\.md)\)")
_RX_HEADING = re.compile(r"^(#{1,6})\s+(.*)$")
_RX_SEPARADOR = re.compile(r":?-{3,}:?")


def _inline(texto: str) -> str:
    """Escapa HTML e aplica a marcação inline mínima (code, negrito, link)."""
    s = html.escape(texto, quote=True)
    s = re.sub(r"`([^`]+)`", r"<code>\1</code>", s)
    s = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", s)
    s = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'<a href="\2">\1</a>', s)
    return s


def _tabela(linhas: list[str]) -> str:
    filas: list[list[str]] = []
    for linha in linhas:
        celas = [c.strip() for c in linha.strip().strip("|").split("|")]
        if all(_RX_SEPARADOR.fullmatch(c) for c in celas):
            continue  # linha separadora do markdown
        filas.append(celas)
    if not filas:
        return ""
    partes = ["<table>",
              "<tr>" + "".join(f"<th>{_inline(c)}</th>" for c in filas[0]) + "</tr>"]
    for fila in filas[1:]:
        partes.append("<tr>" + "".join(f"<td>{_inline(c)}</td>" for c in fila) + "</tr>")
    partes.append("</table>")
    return "".join(partes)


def md_para_html(md: str) -> str:
    """Converte o subconjunto de Markdown dos templates do hub para HTML.

    Cobre: headings, fences (```mermaid vira <div class="mermaid">), tabelas,
    listas '-', blockquotes e parágrafos. Não é um conversor genérico — só o
    que os templates da trilha produzem (spec §9, risco do parser).
    """
    saida: list[str] = []
    linhas = md.splitlines()
    i = 0
    while i < len(linhas):
        linha = linhas[i]
        if linha.startswith("```"):
            lang = linha[3:].strip().lower()
            corpo: list[str] = []
            i += 1
            while i < len(linhas) and not linhas[i].startswith("```"):
                corpo.append(linhas[i])
                i += 1
            i += 1  # consome o fence de fechamento
            conteudo = html.escape("\n".join(corpo), quote=False)
            if lang == "mermaid":
                saida.append(f'<div class="mermaid">{conteudo}</div>')
            else:
                saida.append(f"<pre><code>{conteudo}</code></pre>")
            continue
        m = _RX_HEADING.match(linha)
        if m:
            nivel = len(m.group(1))
            saida.append(f"<h{nivel}>{_inline(m.group(2))}</h{nivel}>")
            i += 1
            continue
        if linha.startswith("|"):
            bloco: list[str] = []
            while i < len(linhas) and linhas[i].startswith("|"):
                bloco.append(linhas[i])
                i += 1
            saida.append(_tabela(bloco))
            continue
        if linha.startswith("- "):
            itens: list[str] = []
            while i < len(linhas) and linhas[i].startswith("- "):
                itens.append(f"<li>{_inline(linhas[i][2:])}</li>")
                i += 1
            saida.append("<ul>" + "".join(itens) + "</ul>")
            continue
        if linha.startswith(">"):
            saida.append(f"<blockquote>{_inline(linha.lstrip('> '))}</blockquote>")
            i += 1
            continue
        if linha.strip():
            saida.append(f"<p>{_inline(linha)}</p>")
        i += 1
    return "\n".join(saida)


def _e_artefato_visual(caminho: Path, raiz: Path) -> bool:
    """Gate 1 só embute artefatos visuais (spec §6.2) — o resto fica como link."""
    rel = caminho.relative_to(raiz).as_posix()
    return caminho.name == "FLUXO-TELAS.md" or rel.startswith("docs/architecture/")


def artefatos_linkados(md: str, raiz_projeto: Path, origem: Path) -> list[Path]:
    """Artefatos .md linkados, resolvidos e contidos na raiz do projeto.

    Cada link é tentado primeiro relativo à pasta do arquivo de origem
    (convenção: link relativo ao próprio manifesto) e, se não existir ou
    ficar fora da raiz, relativo à raiz do projeto. Link que não resolve por
    nenhum dos dois caminhos gera aviso em stderr e não entra na lista.
    """
    raiz = raiz_projeto.resolve()
    vistos: list[Path] = []
    for rel in _RX_LINK_MD.findall(md):
        resolvido = None
        for base in (origem.parent, raiz):
            p = (base / rel).resolve()
            if p.is_file() and raiz in p.parents:
                resolvido = p
                break
        if resolvido is None:
            print(f"AVISO: link .md não incluído no gate (fora da raiz ou inexistente): {rel}",
                  file=sys.stderr)
            continue
        if resolvido not in vistos:
            vistos.append(resolvido)
    return vistos


def _secao(fonte: str, md: str, classe: str = "") -> str:
    attr_classe = f' class="{classe}"' if classe else ""
    return (f'<section{attr_classe} data-fonte="{html.escape(fonte, quote=True)}">'
            f"{md_para_html(md)}</section>")


def _garantir_assets(workspace: Path) -> None:
    """Copia o mermaid.min.js vendorado para docs/planos/assets/ (1× por projeto)."""
    origem = Path(__file__).parent / "assets" / "mermaid.min.js"
    destino = workspace.parent / "assets" / "mermaid.min.js"
    if origem.is_file() and not destino.is_file():
        destino.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(origem, destino)


def gerar(workspace: Path, gate: int) -> Path:
    nome_html, titulo, fontes = GATES[gate]
    workspace = workspace.resolve()
    if workspace.parent.name != "planos" or workspace.parent.parent.name != "docs":
        raise SystemExit(f"ERRO: workspace precisa estar em <raiz>/docs/planos/<nome>: {workspace}")
    raiz_projeto = workspace.parents[2]  # <raiz>/docs/planos/<ws>
    secoes: list[str] = []
    for fonte in fontes:
        caminho = workspace / fonte
        if not caminho.is_file():
            raise SystemExit(f"ERRO: fonte do gate {gate} ausente: {caminho}")
        md = caminho.read_text(encoding="utf-8")
        secoes.append(_secao(fonte, md))
        if gate == 1:
            for art in artefatos_linkados(md, raiz_projeto, caminho):
                if not _e_artefato_visual(art, raiz_projeto):
                    continue
                rel = art.relative_to(raiz_projeto).as_posix()
                secoes.append(_secao(rel, art.read_text(encoding="utf-8"), "artefato"))
    if gate == 3:
        for brief in sorted((workspace / "tarefas").glob("T*-brief.md")):
            secoes.append(_secao(f"tarefas/{brief.name}",
                                 brief.read_text(encoding="utf-8"), "brief"))
    template = (Path(__file__).parent / "assets" / "gate-template.html")
    pagina = (template.read_text(encoding="utf-8")
              .replace("{{TITULO}}", html.escape(f"{titulo} · {workspace.name}"))
              .replace("{{CONTEUDO}}", "\n".join(secoes)))
    destino_dir = workspace / "visual"
    destino_dir.mkdir(parents=True, exist_ok=True)
    destino = destino_dir / nome_html
    destino.write_text(pagina, encoding="utf-8")
    _garantir_assets(workspace)
    return destino


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(
        description="Gera a página HTML de um gate da trilha de planejamento.")
    ap.add_argument("workspace", type=Path, help="docs/planos/<data>-<nome>/")
    ap.add_argument("--gate", type=int, required=True, choices=sorted(GATES))
    args = ap.parse_args(argv)
    if not args.workspace.is_dir():
        raise SystemExit(f"ERRO: workspace não encontrado: {args.workspace}")
    destino = gerar(args.workspace, args.gate)
    print(f"file://{destino}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
