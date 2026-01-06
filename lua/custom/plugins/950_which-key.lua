-- key help, to be loaded after most of the plugins have been loaded
-- this plugin helps user understand and learn key combinations
-- moved to 950_which-key.lua from lazy.lua on jan 06 2026 (mgua@tomware.it)
--
-- to see keymaps you can user :imap :nmap :vmap
--
-- the actual mappings definitions are in several places
-- - inside neovim itself
-- - inside the plugins
-- -- in the keymap files
--      config/first-keymaps.lua
--      config/last-keymaps.lua
--

return {
  'folke/which-key.nvim',
  -- WhichKey is a useful plugin that displays a popup with possible key bindings
  -- of the command you started typing. https://github.com/folke/which-key.nvim
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {                    -- your configuration comes here
      plugins = {
        spelling = {
          enabled = true,
        }
      },
      presets = {             -- Presets table is for native Vim/Neovim keybinding help
        operators = false,    -- Help for d, y, etc.
        motions = false,      -- Help for j, k, w, etc.
        text_objects = false, -- Help for iw, a}, etc.
        windows = false,      -- Help for <C-w> bindings
        nav = false,          -- Help for misc bindings
        z = true,             -- Enable bindings for folds, spelling, etc. (all 'z' keys)
        g = true,             -- Help for g-prefixed bindings
      },
      triggers = {
        { "<leader>", mode = { "n", "v" } },    -- normal and visual mode
      },
      spec = {
        { "<leader>h", group = "Git hunks (gitsigns)" },
        { "<leader>m", group = "MergeDiff/Markdown" },
        { "<leader>g", group = "LazyGit/LSP-goto/Comment" },
      },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

