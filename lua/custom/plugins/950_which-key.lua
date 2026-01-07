-- 950_which-key.lua
-- key help, to be loaded after most of the plugins have been loaded
-- this plugin helps user understand and learn key combinations
-- https://github.com/folke/which-key.nvim
--
-- Place in: lua/custom/plugins/950_which-key.lua
--
-- to see keymaps you can use :imap :nmap :vmap
-- to debug a specific key: :verbose nmap ]b

return {
  'folke/which-key.nvim',
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    plugins = {
      spelling = { enabled = true },
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
    triggers = {
      { "<leader>", mode = { "n", "v" } },
      { "[", mode = { "n", "v" } },
      { "]", mode = { "n", "v" } },
      { "g", mode = { "n", "v" } },
      { "z", mode = { "n", "v" } },
      { "<C-w>", mode = { "n" } },
    },
    spec = {
      -- ====== Leader Groups ======
      { "<leader>b",  desc = "Buffers (fzf)" },
      { "<leader>B",  desc = "Buffer list (simple)" },

      -- Find/Fzf group
      { "<leader>f",  group = "Find/Fzf" },
      { "<leader>ff", desc = "Find files" },
      { "<leader>fF", desc = "Find ALL files" },
      { "<leader>fr", desc = "Recent files" },
      { "<leader>fg", desc = "Live grep" },
      { "<leader>fG", desc = "Live grep (resume)" },
      { "<leader>fw", desc = "Grep word" },
      { "<leader>fW", desc = "Grep WORD" },
      { "<leader>f/", desc = "Grep buffer" },
      { "<leader>fs", desc = "Document symbols" },
      { "<leader>fS", desc = "Workspace symbols" },
      { "<leader>fd", desc = "Diagnostics (buffer)" },
      { "<leader>fD", desc = "Diagnostics (workspace)" },
      { "<leader>fi", desc = "Implementations" },
      { "<leader>fR", desc = "References" },
      { "<leader>fh", desc = "Help tags" },
      { "<leader>fk", desc = "Keymaps" },
      { "<leader>fc", desc = "Commands" },
      { "<leader>fC", desc = "Command history" },
      { "<leader>fm", desc = "Marks" },
      { "<leader>fj", desc = "Jump list" },
      { "<leader>fq", desc = "Quickfix list" },
      { "<leader>fl", desc = "Location list" },
      { "<leader>f\"", desc = "Registers" },
      { "<leader>fa", desc = "Autocommands" },
      { "<leader>ft", desc = "Filetypes" },
      { "<leader>fo", desc = "Vim options" },
      { "<leader>f:", desc = "Search history" },
      { "<leader>f.", desc = "All pickers" },
      { "<leader>fL", desc = "Lines (all buffers)" },
      { "<leader>fb", desc = "Lines (buffer)" },

      -- Git group
      { "<leader>g",  group = "Git" },
      { "<leader>gg", desc = "LazyGit" },
      { "<leader>gf", desc = "Git files" },
      { "<leader>gc", desc = "Git commits" },
      { "<leader>gC", desc = "Git commits (buffer)" },
      { "<leader>gb", desc = "Git branches" },
      { "<leader>gS", desc = "Git status" },
      { "<leader>gt", desc = "Git stash" },

      -- Other leader groups
      { "<leader>c",  group = "Copy/Clipboard" },
      { "<leader>h",  group = "Git hunks (gitsigns)" },
      { "<leader>m",  group = "Merge/Markdown" },
      { "<leader>r",  group = "Rename/Refactor" },
      { "<leader>s",  group = "Startify sessions" },
      { "<leader>t",  desc = "NvimTree toggle" },
      { "<leader>e",  desc = "NvimTree focus" },
      { "<leader>w",  desc = "Cycle windows" },
      { "<leader>y",  group = "Yank (osc52)" },
      { "<leader><leader>", desc = "Resume last picker" },

      -- ====== Bracket Navigation ======
      { "]",  group = "Next..." },
      { "[",  group = "Previous..." },
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

      -- ====== g prefix ======
      { "g",  group = "Goto/Actions" },
      { "gd", desc = "Go to definition" },
      { "gD", desc = "Go to declaration" },
      { "gr", desc = "Go to references" },
      { "gi", desc = "Go to implementation" },

      -- ====== z prefix ======
      { "z",  group = "Folds/Spelling/View" },
    },
  },
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer Local Keymaps",
    },
    {
      "<leader>k",
      function() require("which-key").show({ global = true }) end,
      desc = "All Keymaps",
    },
  },
}
