# CheatSheet - LazyVim + Snacks + Neovim
> `<leader>` = Espaço. Aperte `<leader>` e espere: o **which-key** mostra tudo.

## Janelas / Buffers / Tabs
| Tecla | Ação |
|---|---|
| `<C-h/j/k/l>` | Mover entre janelas |
| `<C-Up/Down/Left/Right>` | Redimensionar janela |
| `<leader>-` / `<leader>\|` | Split horizontal / vertical |
| `<leader>wd` | Fechar janela |
| `<S-h>` / `<S-l>` | Buffer anterior / próximo |
| `<leader>bb` | Alternar buffer |
| `<leader>bd` / `<leader>bD` | Deletar buffer / buffer + janela |
| `<leader><tab>` + letra | Tabs (`<tab>n` nova, `<tab>d` fecha, `<tab>l` última) |
| `<leader>e` | Explorer (árvore); busca `/` acha arquivos e pastas; `S`/`Alt+s` = Só pastas; `H`/`Alt+h` = ocultos |

---
## Arquivos / Finder (Snacks)
| Tecla | Ação |
|---|---|
| `<leader><space>` | Find Files (raiz) |
| `<leader>ff` / `<leader>fF` | Arquivos (raiz / cwd) |
| `<leader>fg` | Arquivos do git |
| `<leader>fr` / `<leader>fR` | Recentes (todos / cwd) |
| `<leader>fp` | Projetos |
| `<leader>fD` | Pastas/Diretórios (`H`/`Alt+h` alterna ocultas; Enter abre no Explorer) |
| `<leader>fc` | Config do LazyVim |
| `<leader>fb` / `<leader>fB` | Buffers (visíveis / todos) |
| `<leader>fn` | Novo arquivo |
| `<leader>/` | Grep (raiz) |
| `<leader>:` | Histórico de comandos |

---
## Busca (s)
| Tecla | Ação |
|---|---|
| `<leader>sg` / `<leader>sG` | Grep ao vivo (raiz / cwd) |
| `<leader>sw` / `<leader>sW` | Palavra sob o cursor (raiz / cwd) |
| `<leader>sb` / `<leader>sB` | Linhas de buffer / Grep em buffers |
| `<leader>sd` / `<leader>sD` | Diagnósticos (Workspace / Buffer) |
| `<leader>sh` / `<leader>sH` | Help / Highlights |
| `<leader>sk` / `<leader>sJ` | Keymaps / Jumps |
| `<leader>ss` / `<leader>sS` | Símbolos LSP (arquivo / Workspace) |
| `<leader>st` / `<leader>sT` | TODOs (todos / TODO+FIX+FIXME) |
| `<leader>sm` / `<leader>sl` | Marks / Location list |
| `<leader>sq` / `<leader>SR` | Quickfix / Resume |

--- 
## Git (g)
| Tecla | Ação |
|---|---|
| `<leader>gg` / `<leader>gG` | Lazygit (raiz / cwd) |
| `<leader>gb` | Blame da linha |
| `<leader>gf` / `<leader>gl` | Histórico do arquivo / log |
| `<leader>gd` / `<leader>gD` | Diff hunks (Worktree / Origin) |
| `<leader>gs` / `<leader>gS` | Status / Stash |

---
## Código / LSP
| Tecla | Ação |
|---|---|
| `gd` / `gD` | Definição / Declaração |
| `gr` | Referências |
| `gI` / `gy` | Implementação / Tipo |
| `K` / `gK` | Hover / Assinatura |
| `<leader>ca` / `<leader>cA` | Code action / Source action |
| `<leader>cr` | Renomear símbolo |
| `<leader>cd` | Diagnósticos da linha (float) |
| `<leader>cs` / `<leader>cS` | Símbolos / Símbolos LSP (Trouble) |
| `<leader>cl` | Info dos LSPs |
| `<leader>cm` | Mason |
| `[d` / `]d` | Diagnóstico anterior / próximo |
| `[e` / `]e` | Erro anterior / próximo |

---
## Diagnósticos / Trouble (x)
| Tecla | Ação |
|---|---|
| `<leader>xx` | Lista de Diagnósticos (Trouble) |
| `<leader>xX` | Só do buffer atual |
| `<leader>xL` / `<leader>xQ` | Loclist / Quickfix |
| `<leader>xt` / `<leader>xT` | TODOs (todos / TODO+FIX+FIXME) |

---
## Toggles (u)
| Tecla | Ação |
|---|---|
| `<leader>us` | **Spell** (corretor) |
| `<leader>uw` | Wrap |
| `<leader>ul` / `<leader>uL` | Número de linha / relativo |
| `<leader>ub` | Fundo claro/escuro |
| `<leader>uf` / `<leader>uF` | Formatar ao salvar (buffer / global) |
| `<leader>ud` | Diagnósticos inline |
| `<leader>ug` | Guias de indentação |
| `<leader>uc` | Conceallevel |
| `<leader>uh` | Inlay hints |
| `<leader>uT` | Treesitter |
| `<leader>un` | Dispensar notificações |
| `<leader>ui` | Inspecionar posição do cursor |

---
## Spell
| Tecla | Ação |
|---|---|
| `<leader>us` | Liga/Desliga |
| `]s` / `[s` | Próximo / Anterior erro |
| `z=` | Sugestões |
| `zg` / `zw` | Adicionar / Remover palavra do dicionário |
| `zug` | Desfazer `zg`/`zw` |
> Liga sozinho em: **markdown, text, gitcommit, tex**.

---
## LaTeX / VimTeX
| Tecla | Ação |
|---|---|
| `\ll` | Compilar (latexmk) |
| `\lv` | Abrir PDF (zathura) |
| `\le` | Lista de erros |
| `\lk` | Parar compilação |
| `\lK` | Limpar arquivos auxiliares |
| `<leader>K` | Documentação do pacote |

---
## Obsidian (vault `~/.vault`)
| Tecla | Ação |
|---|---|
| `<leader>on` / `<leader>od` | Nota nova / nota diária |
| `<leader>oD` | Listar notas diárias |
| `<leader>of` | Buscar nota |
| `<leader>og` | Grep no vault |
| `<leader>ob` / `<leader>ol` | Backlinks / Links da nota |
| `<leader>om` / `<leader>ot` | Bookmarks / Inserir template |
| `<leader>oT` | Nova nota a partir de template |
| `<leader>or` | Renomear nota (atualiza Backlinks) |
| `<leader>oc` | Alternar checkbox |
| `<leader>oa` | Abrir no app Obsidian |

---
## Terminal / Sessão / Noice 
| Tecla | Ação |
|---|---|
| `<leader>ft` / `<leader>fT` | Terminal (raiz / cwd) |
| `<leader>qq` | Sair de tudo |
| `<leader>l` | Lazy (gerenciador de plugins) |
| `<leader>snl` / `<leader>snh` | Noice: última mensagem / histórico |
| `<leader>snd` | Noice: dispensar tudo |
| `<leader>uC` | Trocar colorscheme |

---
