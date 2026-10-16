return {
  -- LSP para Bash (bash-language-server) - instalado pelo Mason
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
  -- Parser extras de sintaxe (bash, awk e sed)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "bash", "awk" } },
  },
}
