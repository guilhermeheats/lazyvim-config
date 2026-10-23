# Melhorias

## Terminals:
- [x] WezTerm instalado.
- [x] Atalho para o XFCE verificado.
  - `exo-open --launch TerminalEmulator` → `wezterm-gui`
- [ ] Configurar Nerd Font Fallback para os terminais.
  - Principalmente no WezTerm
- [ ] WezTerm com o Visual do XFCE
  - Dracula, MesloLGS NF 15, opacidade 0.9
- [ ] Kitty com mesmo visual - Fallback
- [ ] Ghostty com o mesmo visual - Fallback 2
- [ ] Fallback automático
  - WezTerm → Kitty → Ghostty.
- [ ] Configs versionadas no repo.
  - `terminal/wezterm.lua`, `terminal/kitty.conf`, `terminal/ghostty.toml`.
  - Wrapper e helper.
- [ ] `setup.sh` e `README.md` atualizados.
---

## Neovim:
- [x] Formatação automática ao salvar - Desligada
  - `vim.g.autoformat = false`
- [ ] Corrigir Spell Checking
  - `spellang = { "pt", "en" }`
- [ ] Decidir toggle de spell
  - `<leader>us`, `:setlocal spell!`
- [ ] Cheatsheet de comandos - Snacks e do Neovim
- [ ] Debloat dos plugins padrões do LazyVim
- [ ] Identificar outros pontos de melhoria
---

## Memória:
- [x] `nvim --embed` identificado como servidor interno do TUI.
  - Não é vazamento.
- [ ] Limitar a memória do buffer
  - bigfile/scrollback
- [ ] Finder subindo muito o consumo de RAM
  - **Excludes para Games**, Android, node_modules, target, .venv
- [ ] Medir RSS
  - Antes e depois do finder
---
