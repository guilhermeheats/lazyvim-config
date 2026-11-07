# Melhorias

## Terminals:
- [x] WezTerm instalado.
- [x] Atalho para o XFCE verificado.
  - `exo-open --launch TerminalEmulator` → `wezterm`
  - `~/.local/bin/terminal-emulator.sh` → WezTerm
- [x] Configurar Nerd Font Fallback para os terminais.
  - Principalmente no WezTerm
- [x] WezTerm com o Visual do XFCE
  - Dracula, MesloLGS NF 14.5, opacidade 0.9
- [x] Kitty com mesmo visual - Fallback
- [x] Ghostty com o mesmo visual - Fallback 2
- [x] Fallback automático
  - WezTerm → Kitty → Ghostty.
- [x] Configs versionadas no repo.
  - `terminal/wezterm.lua`, `terminal/kitty.conf`, `terminal/ghostty.conf`
  - Wrapper e helper.
- [x] `setup.sh` e `README.md` atualizados. ---

## Neovim:
- [x] Formatação automática ao salvar - Desligada
  - `vim.g.autoformat = false`
- [x] Corrigir Spell Checking
  - `spelllang = { "pt", "pt_br", "en" }`
- [x] Decidir toggle de spell
  - `<leader>us` (Snacks.toggle), `:setlocal spell!`, spell automático em markdown/text/gitcommit/tex
- [x] Cheatsheet de comandos - Snacks e do Neovim
- [x] Snacks
  - Adicionar a função do Explorer procurar apenas pastas/diretórios.
  - `<leader>fD` → "Find Dirs" (fd), Enter abre a pasta no Explorer
- [x] Debloat dos plugins padrões do LazyVim
  - Não necessário: Plugins já são lazy; Nenhum desabilitado.
- [x] Identificar outros pontos de melhoria
  - Docs sincronizados (README/CHEATSHEET), example.lua removido, .luarc.json versionado.
- [x] Atualizar o `README.md` e o `CHEATSHEET.md` - Se precisar, atualizar o `setup.sh`
---

## Memória:
- [x] `nvim --embed` identificado como servidor interno do TUI.
  - Não é vazamento.
- [x] Limitar a memória do buffer
  - bigfile: Snacks (padrão 1.5 MB) já ativo; Scrollback 5000 (WezTerm + Kitty)
- [x] Finder subindo muito o consumo de RAM
  - **Excludes**: Games, Android, node_modules, target, .venv, venv, __pycache__, .cache
- [x] Medir RSS
  - 24 MB ocioso → 30 MB finder (~) com excludes (antes: ~109 MB)
---

## Repo/Git:
- [ ] Versionar todas as mudanças.
- [ ] Subir para o GitHub.
---

## Backlog:
- [x] Keybinds do WezTerm
  - Splits Enter/|, painéis h/j/k/l, redimensionar.
- [x] Cheatsheet dos comandos dos terminais.
  - WezTerm, Kitty, Ghostty.
- [x] Housekeeping:
  - `setup.sh` (dotfiles + vault + link do Projects); wrapper antigo.
- [ ] DAP no Python (debugpy).
---

## Melhorias Gerais:
- [ ] Seguir o XDG no `setup.sh`.
- [x] Verificar integridade do script de setup.
  - Através do GitHub Actions - CI
- [ ] Realizar uma versão do `setup.sh` para o OpenSuse Leap.
---
