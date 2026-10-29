# LazyVim Isolado - Guia de Replicação

  Configuração pessoal de Neovim (**LazyVim**) rodando isolado com (`NVIM_APPNAME=lazyvim`), usada para notas em .md (vault Obsidian), LaTeX com preview (vimtex + zathura) e IDE. 
  Neovim do sistema (`~/.config/nvim`) não é tocado.

## TL;DR (PC Novo - Debian Base x86_64)

```bash
# 1) Clonar este repo (se a pasta ~/.config/lazyvim já existir, remova antes)
git clone git@github.com:guilhermeheats/lazyvim-config.git ~/.config/lazyvim

# 2) Rodar o instalador (pacotes do sistema, Neovim, fonte ...)
bash ~/.config/lazyvim/setup.sh

# 3) Primeira execução - Download de todos os plugins
lazyvim
```

## O que este repo contém:

| Item | Papel |
|---|---|
| `init.lua` + `lua/config/` | Configuração base (options, keymaps, autocmds, bootstrap) |
| `lua/plugins` | Plugins e ajustes (kanagawa-dragon, obsidian.nvim, markdown, vimtex/zathura ...)|
| `lazyvim.json` | Extras ativos do LazyVim (inclui `lang.tex`) |
| `lazy-lock.json` | Versões exatas de todos os plugins | 
| `setup.sh` | Instalador | 
| `terminal/` | Configs dos terminais (WezTerm, Kitty, Ghostty), wrapper, `.desktop` genérico e helper XFCE |

## Terminais (WezTerm → Kitty → Ghostty)

- **Ordem**: WezTerm (principal) → Kitty (fallback) → Ghostty (terceiro fallback).
- **Visual**: Dracula, MesloLGS NF (WezTerm 14.5; Kitty/Ghostty 15), opacidade 0.9.
- **Fontes**: WezTerm e Ghostty usam fallback: `MesloLGS NF → JetBrainsMono Nerd Font → OpenDyslexic Nerd Font → OpenDyslexic`; no Kitty o fallback é automático via fontconfig.
- **Wrapper**: `~/.local/bin/terminal-emulator.sh` abre o primeiro disponível na ordem acima.
  - Forçar um: `TERMINAL_EMULATOR=kitty terminal-emulator.sh` (aceita `wezterm`, `kitty`, `ghostty`).
  - Abrir numa pasta: `terminal-emulator.sh ~/projetos` ou `terminal-emulator.sh --working-directory DIR`.
  - Rodar um comando: `terminal-emulator.sh -e vim arquivo`.
  - `TERMINAL_DEBUG=1` imprime o `exec` em vez de abrir janela.
- **Terminal Padrão (Agnóstico à DE)**: `terminal-emulator.desktop` em `~/.local/share/applications` + `~/.config/xdg-terminals.list` + alternativa `x-terminal-emulator`; por DE: XFCE (helper), GNOME/Unity/Budgie, Cinnamon e MATE (gsettings), LXQt (qtxdg.conf), KDE Plasma (kdeglobals).
- **Instalação**: O `setup.sh` instala os terminais (apt, com fallback do GitHub) e as fontes (MesloLGS NF, JetBrainsMono NF, JetBrains Mono, OpenDyslexic NF e OpenDyslexic)

  Arquivos + Neovim + Internet, **restaura**:

- O `lazy.nvim` se auto-instala e baixa os plugins nas versões exatas do `lazy-lock.json`;
- O Mason instala os servidores (texlab, pyright, marksman...) sozinho, na primeira vez que você abre um arquivo daquele tipo;
- O Treesitter compila os parsers sozinho (precisa do `gcc`, instalado pelo setup).

## O que NÃO está no Repositório (Como resolver):

| Item | Como Reinstalar |
|---|---|
| Neovim v0.12.6 em `~/.local/opt/nvim-lazy/` | `setup.sh` (baixa o tarball oficial) |
| Lançador `~/.local/bin/lazyvim` | `setup.sh`(script de 3 linhas) |
| Pacotes de sistema (LaTeX, Zathura, rg, fd, lazygit, Java...) | `setup.sh` (apt) |
| Fonte: JetBrainsMono Nerd Font, JetBrains Mono, MesloLGS NF, OpenDyslexic NF | `setup.sh` |
| Terminais: WezTerm, Kitty e Ghostty (apt ou GitHub) | `setup.sh` |
| Notas (`~/.vault`) e app Obsidian | Backup à parte - é apenas dado |


  Não precisa copiar (regenera sozinho): `~/.local/share/lazyvim` (plugins, Mason, parsers) e `~/.local/state/lazyvim` (swap, histórico).

## Instalação Manual (sem `setup.sh`):

1. **Pacotes do Sistema**
  
```bash
sudo apt install git ripgrep fd-find lazygit build-essential unzip curl wget nodejs npm python3 \
pipx fontconfig default-jdk-headless texlive-latex-base texlive-latex-recommended \
texlive-latex-extra texlive-fonts-recommended texlive-lang-portuguese texlive-pictures \
latexmk zathura zathura-pdf-poppler

ln -s "$(command -v fdfind)" ~/.local/bin/fd    # Neovim espera o nome 'fd'
```

2. **pylatexenc (Fórmulas nas Notas)**

```bash
pipx install pylatexenc
```

3. **Neovim**

```bash
mkdir -p ~/.local/opt
curl -fL https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-linux-x86_64.tar.gz \
| tar xz -C ~/.local/opt

mv ~/.local/opt/nvim-linux-x86_64 ~/.local/opt/nvim-lazy
```

4. **Lançador**

- Criar o `~/.local/bin/lazyvim` com o conteúdo abaixo e `chmod +x`:

```bash
#!/usr/bin/env bash
export NVIM_APPNAME=lazyvim
exec "$HOME/.local/opt/nvim-lazy/bin/nvim" "$@"
```

- OBS: garantir que o `~/.local/bin`está no PATH do seu shell.

5. **Config**
- Colocar este repositório em `~/.config/lazyvim/`.

## Primeira Execução:

- `lazyvim` → O `lazy.nvim` se instala e restaura tudo - necessita de internet.
- Abra um `.tex` → instala o `texlab`; Um `.md` → `marksman`; um `.py` → `pyright`; etc.
- Confira com `:Lazy` (plugins) · `:Mason`(servidores) · `:checkhealth`.

Uso rápido: `\ll` compila o LaTeX e abre no zathura · `:w` atualiza o PDF · `\lv` pula para o ponto no PDF · `\le` lista os erros · `<leader>um` liga/desliga o render das notas.

## Atualizar/Publicar:

- Publicar mudanças:

```bash
cd ~/.config/lazyvim
git add -A && git commit -m "descrição da mudança"
git push
```

- Puxar nos outros (e rodar `:Lazy sync` no Neovim se o `lazy-lock.json` mudou):

```bash
git -C ~/.config/lazyvim pull
```

## Problemas Comuns: 

- **`W325: Ignoring swapfile ...`** - existe outra sessão do Neovim com o mesmo arquivo aberto (ela segura o swapfile). Feche a outra sessão ou ignore o aviso).
- **Ícones Quebrados** - falta a Nerd Font (instale a JetBrainsMono Nerd Font).
- **`fd` não encontrado** - instale o `fd-find`e crie o link `fd`(Em **Passo 1**).
- **LaTeX não compila** - conferir se o `pdflatex`, `latexmk` e `zathura` estão instalados.
---

