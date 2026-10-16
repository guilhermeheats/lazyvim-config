return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- sempre a última release stable
    lazy = false, -- iniciar junto com o neovim
    opts = function()
      return {
        legacy_commands = false, -- apenas os comandos novos
        workspaces = {
          { name = "Notes", path = "~/.vault" },
        },
        picker = { name = "snacks.picker" }, -- usar o picker padrão do Lazy
        note_id_func = require("obsidian.builtin").title_id, -- nome do arquivo = título da nota
        completion = { min_chars = 2 }, -- autocomplete [[notas]] e #tags a partir de 2 letras

        daily_notes = {
          enabled = true,
          folder = "Daily Notes",
          date_format = "YYYY-MM-DD",
          workdays_only = false, -- todos os dias.
          template = "Daily",
          default_tags = { "daily_notes" },
        },

        templates = { folder = "Templates" },
        attachments = { folder = "Attachments" }, -- images coladas
      }
    end,
    keys = {
      { "<leader>o", group = "Obsidian", icon = "󰈙 " },
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New Note" },
      { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Daily Note" },
      { "<leader>oD", "<cmd>Obsidian dailies<cr>", desc = "List Daily Notes" },
      { "<leader>of", "<cmd>Obsidian quick_switch<cr>", desc = "Search for note" },
      { "<leader>og", "<cmd>Obsidian search<cr>", desc = "Grep in the vault" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Links in the note" },
      { "<leader>om", "<cmd>Obsidian bookmarks<cr>", desc = "Bookmarks" },
      { "<leader>ot", "<cmd>Obsidian template<cr>", desc = "Insert template" },
      { "<leader>oT", "<cmd>Obsidian new_from_template<cr>", desc = "New template" },
      { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Rename note (update backlinks)" },
      { "<leader>oa", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian App" },
      { "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox" },
    },
  },
}
