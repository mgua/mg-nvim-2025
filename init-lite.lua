-- init-lite.lua for neovim (single file, minimal setup)
-- Linux:   ~/.config/nvim/init.lua
-- Windows: %LOCALAPPDATA%\nvim\init.lua
-- mgua@tomware.it 2025-2026 — lite variant of mg-nvim-2025
-- Project Neurocode: Coding Assisted with on-prem inferences & Private AI
-- Requires neovim >= 0.11 — uses native LSP, native OSC52 clipboard
--
-- This is a self-contained single-file config. No lua/ directory needed.
-- Plugins: lazy.nvim, treesitter, fzf-lua, gitsigns, lualine, comment, onedark
-- Everything else uses built-in neovim features (netrw, native LSP, OSC52)

-- =============================================================================
-- BOOTSTRAP LAZY.NVIM
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- BASIC SETTINGS
-- =============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.deprecation_warnings = true

-- Editor
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.scrolloff = 4
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

-- Syntax and folding fallback (overridden by treesitter where available)
vim.opt.syntax = "on"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Locale
vim.env.LANG = "en_US.UTF-8"
vim.env.LC_ALL = "en_US.UTF-8"


-- CLIPBOARD very important settings
if vim.env.TMUX then
  -- Clipboard — native OSC52 in nvim 0.10+ if I put this line it works across tmux
  vim.opt.clipboard = "unnamedplus"
  --  set clipboard+=unnamedplus
  vim.api.nvim_echo({{ "TMUX: vim.opt.clipboard = 'unnamedplus'", "None" }}, false, {})
else
  -- outside tmux it works!!
  vim.g.clipboard = "osc52"
  vim.opt.clipboard = "unnamedplus"
  vim.api.nvim_echo({{ "NO_TMUX: vim.g.clipboard = 'osc52' AND vim.opt.clipboard = 'unnamedplus'", "None" }}, false, {})
end




-- Listchars (visible whitespace)
vim.opt.list = true
vim.opt.listchars = {
  eol = "⏎", tab = "»─", trail = "·", nbsp = "⎵", space = "·",
}

-- Python host (venv_neovim in home folder)
if vim.fn.has("win32") == 1 then
  vim.g.python3_host_prog = vim.env.USERPROFILE .. "/venv_neovim/Scripts/python.exe"
else
  vim.g.python3_host_prog = vim.env.HOME .. "/venv_neovim/bin/python"
end

-- Tmux adjustments
if vim.env.TMUX then
  vim.opt.timeoutlen = 1000
  vim.opt.ttimeoutlen = 0
end

-- =============================================================================
-- KEYMAPS (pre-plugin)
-- =============================================================================
local map = vim.keymap.set

-- Buffer navigation (standard and Italian keyboard)
map("n", "[b", "<cmd>bprev<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "èb", "<cmd>bprev<CR>", { desc = "Previous buffer" })
map("n", "+b", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Tab navigation
map("n", "[t", "gT", { desc = "Previous tab" })
map("n", "]t", "gt", { desc = "Next tab" })

-- Quickfix navigation
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })

-- Window movement
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<leader>w", "<C-w>w", { desc = "Cycle windows" })

-- File explorer (netrw — no nvim-tree needed)
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "File explorer" })
map("n", "<leader>t", "<cmd>Lexplore 30<CR>", { desc = "File tree (netrw)" })

-- Easy actions (CUA-style clipboard)
map({ "n", "i" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })
map("v", "<C-c>", '"+y', { desc = "Copy" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
map("v", "<C-x>", '"+d', { desc = "Cut" })
map("v", "<C-Insert>", '"+y', { desc = "Copy (classic)" })
map({ "n", "i", "v", "c" }, "<S-Insert>", function()
  local mode = vim.fn.mode()
  if mode == "i" or mode == "c" then return "<C-r>+" end
  return '"+gP'
end, { expr = true, desc = "Paste (classic)" })

-- Yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function() vim.highlight.on_yank({ timeout = 250 }) end,
})

-- =============================================================================
-- PLUGINS (lazy.nvim)
-- =============================================================================
require("lazy").setup({

  -- Colorscheme
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function() vim.cmd.colorscheme("onedark") end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        theme = "onedark",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  -- Treesitter (syntax, folds, indentation)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      install = {
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "html", "css", "python", "powershell", "bash",
          "json", "yaml", "markdown", "markdown_inline",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      -- Apply treesitter folding/indentation for supported filetypes
      local ts_filetypes = {
        "c", "lua", "vim", "vimdoc", "query", -- nvim core parsers
        "html", "css", "python", "powershell", "bash",
        "json", "yaml", "markdown", "markdown_inline",
      }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = ts_filetypes,
        callback = function()
          local ok = pcall(vim.treesitter.start)
          if ok then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldlevel = 99
          end
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Fuzzy finder (fzf-lua — fast, single dependency)
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        fzf_bin = "fzf",
        winopts = {
          height = 0.85, width = 0.80,
          border = "rounded",
          preview = { layout = "vertical", vertical = "down:45%" },
        },
        files = {
          fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules",
        },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden -g '!.git'",
        },
      })
      map("n", "<leader>b", fzf.buffers, { desc = "Buffers" })
      map("n", "<leader>ff", fzf.files, { desc = "Find files" })
      map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
      map("n", "<leader>fh", fzf.helptags, { desc = "Help tags" })
      map("n", "<leader>fo", fzf.oldfiles, { desc = "Recent files" })
      map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
      map("n", "<leader>fd", fzf.diagnostics_document, { desc = "Diagnostics" })
      map("n", "<leader>fr", fzf.lsp_references, { desc = "LSP references" })
      map("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "LSP symbols" })
      map("n", "<leader>fc", fzf.git_commits, { desc = "Git commits" })
      map("n", "<leader>fb", fzf.git_branches, { desc = "Git branches" })
    end,
  },

  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local bmap = function(mode, l, r, desc)
          map(mode, l, r, { buffer = bufnr, desc = desc })
        end
        bmap("n", "]h", gs.next_hunk, "Next hunk")
        bmap("n", "[h", gs.prev_hunk, "Previous hunk")
        bmap("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        bmap("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        bmap("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        bmap("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        bmap("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        bmap("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
      end,
    },
  },

  -- Commenting
  { "numToStr/Comment.nvim", event = "BufReadPre", opts = {} },

  -- Color code previews
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "virtual",
        virtual_symbol = "■",
        virtual_symbol_position = "inline",
      })
    end,
  },

}, { -- lazy.nvim options
  rocks = { enabled = false, hererocks = false },
})

-- =============================================================================
-- VS CODE-LIKE COLORS (applied after colorscheme loads)
-- =============================================================================
local hi = vim.api.nvim_set_hl

-- Treesitter captures
hi(0, "@type",              { fg = "#4EC9B0" })
hi(0, "@type.builtin",      { fg = "#4EC9B0" })
hi(0, "@constructor",       { fg = "#4EC9B0" })
hi(0, "@module",            { fg = "#4EC9B0" })
hi(0, "@function",          { fg = "#DCDCAA" })
hi(0, "@function.call",     { fg = "#DCDCAA" })
hi(0, "@function.builtin",  { fg = "#DCDCAA" })
hi(0, "@method",            { fg = "#DCDCAA" })
hi(0, "@method.call",       { fg = "#DCDCAA" })
hi(0, "@variable",          { fg = "#9CDCFE" })
hi(0, "@variable.parameter",{ fg = "#9CDCFE" })
hi(0, "@parameter",         { fg = "#9CDCFE" })
hi(0, "@keyword",           { fg = "#569CD6" })
hi(0, "@keyword.function",  { fg = "#569CD6" })
hi(0, "@keyword.return",    { fg = "#C586C0" })
hi(0, "@keyword.import",    { fg = "#C586C0" })
hi(0, "@include",           { fg = "#C586C0" })
hi(0, "@string",            { fg = "#CE9178" })
hi(0, "@number",            { fg = "#B5CEA8" })
hi(0, "@comment",           { fg = "#6A9955", italic = true })

-- LSP semantic tokens
hi(0, "@lsp.type.namespace", { fg = "#4EC9B0" })
hi(0, "@lsp.type.function",  { fg = "#DCDCAA" })
hi(0, "@lsp.type.method",    { fg = "#DCDCAA" })
hi(0, "@lsp.type.class",     { fg = "#4EC9B0" })
hi(0, "@lsp.type.variable",  { fg = "#9CDCFE" })
hi(0, "@lsp.type.parameter", { fg = "#9CDCFE" })

-- HTML/template
hi(0, "@tag",                { fg = "#569CD6" })
hi(0, "@tag.builtin",        { fg = "#569CD6" })
hi(0, "@tag.delimiter",      { fg = "#808080" })
hi(0, "@tag.attribute",      { fg = "#9CDCFE" })
hi(0, "@operator",           { fg = "#D4D4D4" })
hi(0, "@constant",           { fg = "#4FC1FF" })
hi(0, "@markup.heading",     { fg = "#569CD6", bold = true })
hi(0, "@markup.link",        { fg = "#CE9178" })

-- Matching parentheses
hi(0, "MatchParen", { bg = "#ff8800", fg = "#000000", bold = true })

-- =============================================================================
-- NATIVE LSP (neovim 0.11+ — no mason, no lspconfig plugin needed)
-- =============================================================================
-- Install servers manually:
--   npm install -g basedpyright bash-language-server
--   npm install -g vscode-langservers-extracted  (html, css, json)
--   pip install sqls  (or install via package manager)
--   brew/apt/scoop install lua-language-server

-- Server configurations
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      typeCheckingMode = "standard",
      analysis = {
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- Enable servers (only those installed on the system will actually start)
local servers = { "lua_ls", "basedpyright", "bashls", "powershell_es", "html", "cssls" }
for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

-- Diagnostics display
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- LSP keymaps (attached on LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LiteLspConfig", {}),
  callback = function(ev)
    local o = { noremap = true, silent = true, buffer = ev.buf }

    -- Navigation
    o.desc = "Go to definition"
    map("n", "gd", vim.lsp.buf.definition, o)
    o.desc = "Go to declaration"
    map("n", "gD", vim.lsp.buf.declaration, o)
    o.desc = "Go to implementation"
    map("n", "gi", vim.lsp.buf.implementation, o)
    o.desc = "Find references"
    map("n", "gr", vim.lsp.buf.references, o)
    o.desc = "Type definition"
    map("n", "gT", vim.lsp.buf.type_definition, o)

    -- Documentation
    o.desc = "Hover documentation"
    map("n", "K", vim.lsp.buf.hover, o)
    o.desc = "Signature help"
    map("i", "<C-s>", vim.lsp.buf.signature_help, o)

    -- Refactoring
    o.desc = "Rename symbol"
    map("n", "<leader>rn", vim.lsp.buf.rename, o)
    o.desc = "Code action"
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, o)

    -- Diagnostics
    o.desc = "Previous diagnostic"
    map("n", "[d", vim.diagnostic.goto_prev, o)
    o.desc = "Next diagnostic"
    map("n", "]d", vim.diagnostic.goto_next, o)
    o.desc = "Line diagnostics"
    map("n", "<leader>ld", vim.diagnostic.open_float, o)

    -- Format
    o.desc = "Format"
    map({ "n", "v" }, "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, o)
  end,
})

-- =============================================================================
-- MERGETOOL KEYMAPS
-- =============================================================================
map("n", "<leader>ml", "<cmd>diffget LOCAL<cr>", { desc = "Get from LOCAL" })
map("n", "<leader>mb", "<cmd>diffget BASE<cr>", { desc = "Get from BASE" })
map("n", "<leader>mr", "<cmd>diffget REMOTE<cr>", { desc = "Get from REMOTE" })

-- =============================================================================
-- end of init-lite.lua
-- =============================================================================

