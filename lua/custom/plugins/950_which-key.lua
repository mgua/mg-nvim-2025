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

      -- AI Assistant group (codecompanion)
      { "<leader>a",  group = "AI Assistant" },
      { "<leader>aa", desc = "AI: Toggle Chat" },
      { "<leader>an", desc = "AI: New Chat" },
      { "<leader>ac", desc = "AI: Actions Menu" },
      { "<leader>aq", desc = "AI: Quick Question" },
      { "<leader>as", desc = "AI: Switch Model" },
      { "<leader>ai", desc = "AI: Inline Assist (visual)" },
      { "<leader>ae", desc = "AI: Explain Code (visual)" },
      { "<leader>ar", desc = "AI: Review Code (visual)" },
      { "<leader>af", desc = "AI: Fix Code (visual)" },
      { "<leader>at", desc = "AI: Generate Tests (visual)" },
      { "<leader>ad", desc = "AI: Add Docs (visual)" },

      -- Buffers group
      { "<leader>b",  desc = "Buffers (fzf)" },
      { "<leader>B",  desc = "Buffer list (simple)" },

      -- Find/Fzf group
      { "<leader>f",  group = "Find/Fzf" },
      { "<leader>ff", desc = "Find files" },
      { "<leader>fF", desc = "Find ALL files" },
      { "<leader>fr", desc = "Recent files" },
      { "<leader>fg", desc = "Live grep" },
      { "<leader>fG", desc = "Grep from buffer dir" },
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

      -- LSP group (keymaps defined in 200_mason.lua)
      { "<leader>l",  group = "LSP" },
      { "<leader>lf", desc = "Format code" },
      { "<leader>li", desc = "LSP info (:checkhealth lsp)" },
      { "<leader>lr", desc = "Restart LSP" },

      -- Code actions / Refactoring
      { "<leader>c",  group = "Code/Copy" },
      { "<leader>ca", desc = "Code action" },

      { "<leader>r",  group = "Rename/Refactor" },
      { "<leader>rn", desc = "Rename symbol" },

      -- Other leader groups
      { "<leader>h",  group = "Git hunks (gitsigns)" },
      { "<leader>m",  group = "Merge/Markdown" },
      { "<leader>mp", desc = "Markdown preview" },
      { "<leader>ml", desc = "Merge: get LOCAL" },
      { "<leader>mb", desc = "Merge: get BASE" },
      { "<leader>mr", desc = "Merge: get REMOTE" },
      { "<leader>md", desc = "Merge: diff update" },

      { "<leader>s",  group = "Startify sessions" },
      { "<leader>ss", desc = "Session save" },
      { "<leader>sl", desc = "Session load" },
      { "<leader>sd", desc = "Session delete" },
      { "<leader>sc", desc = "Session close" },

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

      -- ====== g prefix (LSP navigation) ======
      { "g",  group = "Goto/LSP" },
      { "gd", desc = "Definition" },
      { "gD", desc = "Declaration" },
      { "gr", desc = "References" },
      { "gi", desc = "Implementation" },
      { "gT", desc = "Type definition" },

      -- ====== K - Hover ======
      -- K is the standard key for hover documentation (no group needed)

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
    -- Quick LSP info
    {
      "<leader>li",
      "<cmd>checkhealth lsp<CR>",
      desc = "LSP health check",
    },
    -- Restart all LSP clients (Neovim 0.11+)
    {
      "<leader>lr",
      function()
        for _, client in ipairs(vim.lsp.get_clients()) do
          vim.lsp.stop_client(client.id)
        end
        vim.defer_fn(function()
          vim.cmd("edit")
        end, 100)
        vim.notify("LSP clients restarted", vim.log.levels.INFO)
      end,
      desc = "Restart LSP",
    },
  },
}
