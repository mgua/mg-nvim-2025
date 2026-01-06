-- 950_which-key.lua
-- key help, to be loaded after most of the plugins have been loaded
-- this plugin helps user understand and learn key combinations
-- moved to 950_which-key.lua from lazy.lua on jan 06 2026 (mgua@tomware.it)
--
-- to see keymaps you can use :imap :nmap :vmap
-- to debug a specific key: :verbose nmap ]b
-- to debug a group of keys: :verbose nmap ]  (all the keysmaps prefixed by ])
--
-- the actual mappings definitions are in several places
-- - inside neovim itself
-- - inside the plugins
-- - in the keymap files
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
    vim.o.timeoutlen = 500  -- slightly longer to allow bracket combos
  end,
  opts = {
    plugins = {
      spelling = {
        enabled = true,
      },
    },
    presets = {
      operators = false,    -- Help for d, y, etc.
      motions = false,      -- Help for j, k, w, etc.
      text_objects = false, -- Help for iw, a}, etc.
      windows = true,       -- Help for <C-w> bindings (useful!)
      nav = true,           -- Help for misc bindings (enables ] and [ help)
      z = true,             -- Enable bindings for folds, spelling, etc.
      g = true,             -- Help for g-prefixed bindings
    },
    -- triggers configuration for which-key v3.x
    triggers = {
      { "<leader>", mode = { "n", "v" } },
      { "[", mode = { "n", "v" } },         -- Enable [ prefix help
      { "]", mode = { "n", "v" } },         -- Enable ] prefix help
      { "g", mode = { "n", "v" } },         -- Enable g prefix help
      { "z", mode = { "n", "v" } },         -- Enable z prefix help (folds)
      { "<C-w>", mode = { "n" } },          -- Enable window commands help
    },
    -- Group definitions for organized keymap display
    spec = {
      -- Leader groups
      { "<leader>b", desc = "Buffer picker (fzf)" },
      { "<leader>B", desc = "Buffer list + select" },
      { "<leader>c", group = "Copy/Clipboard" },
      { "<leader>f", desc = "Format code (LSP)" },
      { "<leader>g", group = "Git/LazyGit/goto" },
      { "<leader>h", group = "Git hunks (gitsigns)" },
      { "<leader>m", group = "Merge/Markdown" },
      { "<leader>r", group = "Rename/Refactor" },
      { "<leader>s", group = "Startify sessions" },
      { "<leader>t", desc = "NvimTree toggle" },
      { "<leader>w", desc = "Cycle windows" },
      { "<leader>y", group = "Yank (osc52)" },

      -- Bracket navigation groups (] for next, [ for prev)
      { "]", group = "Next..." },
      { "[", group = "Previous..." },
      { "]b", desc = "Next buffer" },
      { "[b", desc = "Previous buffer" },
      { "]t", desc = "Next tab" },
      { "[t", desc = "Previous tab" },
      { "]c", desc = "Next conflict/change" },
      { "[c", desc = "Previous conflict/change" },
      { "]d", desc = "Next diagnostic" },
      { "[d", desc = "Previous diagnostic" },
      { "]q", desc = "Next quickfix" },
      { "[q", desc = "Previous quickfix" },
      { "]l", desc = "Next loclist" },
      { "[l", desc = "Previous loclist" },

      -- g prefix (goto commands)
      { "g", group = "Goto/Actions" },
      { "gd", desc = "Go to definition" },
      { "gD", desc = "Go to declaration" },
      { "gr", desc = "Go to references" },
      { "gi", desc = "Go to implementation" },
      { "gT", desc = "Previous tab" },
      { "gt", desc = "Next tab" },

      -- z prefix (folds and more)
      { "z", group = "Folds/Spelling/View" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
    {
      "<leader>k",
      function()
        require("which-key").show({ global = true })
      end,
      desc = "All Keymaps (which-key)",
    },
  },
}

