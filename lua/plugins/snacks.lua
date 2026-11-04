local EXCLUDES = {
  "Games",
  "Android",
  "node_modules",
  "target",
  ".venv",
  "venv",
  "__pycache__",
  ".cache",
}

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fD",
        function()
          Snacks.picker({
            title = "Find Dirs",
            cwd = LazyVim.root(),
            toggles = { hidden = { icon = "H", value = true } },
            win = { list = { keys = { ["H"] = "toggle_hidden" } } },
            confirm = function(picker, item)
              picker:close()
              Snacks.explorer({ cwd = item.file })
            end,
            finder = function(opts, ctx)
              local args = { "--type", "d", "--color", "never", "-E", ".git" }
              if opts.hidden then
                table.insert(args, "--hidden")
              end
              table.insert(args, ".")
              return require("snacks.picker.source.proc").proc(
                ctx:opts({
                  cmd = "fd",
                  args = args,
                  notify = true,
                  transform = function(item)
                    local cwd = vim.fs.normalize(opts.cwd or vim.uv.cwd())
                    item.file = cwd .. "/" .. item.text
                  end,
                }),
                ctx
              )
            end,
          })
        end,
        desc = "Find Dirs",
      },
    },
    opts = {
      picker = {
        sources = {
          files = { exclude = EXCLUDES },
          grep = { exclude = EXCLUDES },
          explorer = {
            exclude = EXCLUDES,
            toggles = { dirs_only = { icon = "S", value = true } },
            actions = {
              toggle_dirs_only = function(picker)
                picker.opts.dirs_only = not picker.opts.dirs_only
                picker.list:set_target()
                picker:find({ refresh = true })
              end,
            },
            win = {
              list = {
                keys = {
                  ["S"] = "toggle_dirs_only",
                  ["<a-s>"] = { "toggle_dirs_only", mode = { "i", "n" } },
                },
              },
              input = {
                keys = {
                  ["<a-s>"] = { "toggle_dirs_only", mode = { "i", "n" } },
                },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      -- Busca do Explorer: com dirs_only ativo (S ou Alt+S), lista apenas diretórios --
      local src = require("snacks.picker.source.explorer")
      local orig = src.search
      src.search = function(o, ctx)
        local finder = orig(o, ctx)
        if not ctx.picker.opts.dirs_only then
          return finder
        end
        return function(cb)
          finder(function(item)
            if item.dir then
              cb(item)
            end
          end)
        end
      end
    end,
  },
}
