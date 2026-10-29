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
- [x] `setup.sh` e `README.md` atualizados.
---

## Neovim:
- [x] Formatação automática ao salvar - Desligada
  - `vim.g.autoformat = false`
- [x] Corrigir Spell Checking
  - `spelllang = { "pt", "pt_br", "en" }`
- [ ] Decidir toggle de spell
  - `<leader>us`, `:setlocal spell!`
- [ ] Cheatsheet de comandos - Snacks e do Neovim
- Snacks
  - Adicionar a função do Explorer procurar apenas pastas/diretórios.
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

## Repo/Git:
- [ ] Versionar todas as mudanças.
- [ ] Subir para o GitHub.
