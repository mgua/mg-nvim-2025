-- 120_fzf-lua.lua
-- Lightning fast fuzzy finder for Neovim
-- https://github.com/ibhagwan/fzf-lua
--
-- Place in: lua/custom/plugins/120_fzf-lua.lua
--
-- Prerequisites (Windows):
--   winget install junegunn.fzf
--   winget install sharkdp.fd           (optional, faster file finding)
--   winget install BurntSushi.ripgrep.MSVC  (optional, faster grep)
--
-- After installing, REMOVE the fzf-lua block from lazy.lua to avoid duplicates!

return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.icons"
  },
  event = "VeryLazy",
  config = function()
    local fzf = require('fzf-lua')

    -- ========================================================================
    -- SETUP
    -- ========================================================================
    fzf.setup({
      fzf_bin = 'fzf',

      fzf_opts = {
        ['--layout']       = 'reverse',
        ['--info']         = 'inline',
        ['--header-lines'] = '0',
        ['--no-header']    = '',
        ['--cycle']        = '',
        ['--pointer']      = '>',
        ['--marker']       = '+',
        ['--bind'] = table.concat({
          'ctrl-n:down',
          'ctrl-p:up',
          'ctrl-j:down',
          'ctrl-k:up',
          'ctrl-d:preview-page-down',
          'ctrl-u:preview-page-up',
          'ctrl-a:toggle-all',
          'tab:toggle+down',
          'shift-tab:toggle+up',
          'ctrl-/:toggle-preview',
        }, ','),
      },

      defaults = {
        git_icons   = true,
        file_icons  = true,
        color_icons = true,
        headers     = false,
      },

      winopts = {
        height  = 0.85,
        width   = 0.80,
        row     = 0.35,
        col     = 0.50,
        border  = 'rounded',
        preview = {
          layout    = 'vertical',
          vertical  = 'down:45%',
          delay     = 100,
          scrollbar = true,
        },
      },

      keymap = {
        builtin = {
          ["<C-j>"]   = "down",
          ["<C-k>"]   = "up",
          ["<C-n>"]   = "down",
          ["<C-p>"]   = "up",
          ["<Down>"]  = "down",
          ["<Up>"]    = "up",
          ["<C-d>"]   = "preview-page-down",
          ["<C-u>"]   = "preview-page-up",
          ["<Tab>"]   = "toggle+down",
          ["<S-Tab>"] = "toggle+up",
          ["<C-a>"]   = "toggle-all",
          ["<C-/>"]   = "toggle-preview",
          ["<F1>"]    = "toggle-help",
        },
        fzf = {
          ["ctrl-j"]     = "down",
          ["ctrl-k"]     = "up",
          ["ctrl-n"]     = "down",
          ["ctrl-p"]     = "up",
          ["ctrl-d"]     = "preview-page-down",
          ["ctrl-u"]     = "preview-page-up",
          ["tab"]        = "toggle+down",
          ["shift-tab"]  = "toggle+up",
          ["ctrl-a"]     = "toggle-all",
        },
      },

      actions = {
        files = {
          ["default"] = fzf.actions.file_edit_or_qf,
          ["ctrl-s"]  = fzf.actions.file_split,
          ["ctrl-v"]  = fzf.actions.file_vsplit,
          ["ctrl-t"]  = fzf.actions.file_tabedit,
          ["ctrl-q"]  = fzf.actions.file_sel_to_qf,
        },
        buffers = {
          ["default"] = fzf.actions.buf_edit,
          ["ctrl-s"]  = fzf.actions.buf_split,
          ["ctrl-v"]  = fzf.actions.buf_vsplit,
          ["ctrl-t"]  = fzf.actions.buf_tabedit,
          ["ctrl-x"]  = { fzf.actions.buf_del, fzf.actions.resume },
        },
      },

      -- Picker-specific settings
      buffers = {
        sort_lastused         = true,
        show_unloaded         = false,
        ignore_current_buffer = false,
        cwd_only              = false,
        fzf_opts = { ['--header-lines'] = '0' },
      },

      files = {
        fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules",
        fzf_opts = { ['--header-lines'] = '0' },
      },

      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden -g '!.git'",
        fzf_opts = { ['--header-lines'] = '0' },
      },

      oldfiles = {
        cwd_only = false,
        include_current_session = true,
        fzf_opts = { ['--header-lines'] = '0' },
      },

      git = {
        files   = { fzf_opts = { ['--header-lines'] = '0' } },
        status  = { fzf_opts = { ['--header-lines'] = '0' } },
        commits = { fzf_opts = { ['--header-lines'] = '0' } },
      },

      helptags   = { fzf_opts = { ['--header-lines'] = '0' } },
      keymaps    = { fzf_opts = { ['--header-lines'] = '0' } },
      commands   = { fzf_opts = { ['--header-lines'] = '0' } },
      diagnostics = { fzf_opts = { ['--header-lines'] = '0' } },
    })

    -- ========================================================================
    -- KEYMAPS
    -- ========================================================================
    local map = vim.keymap.set

    -- Helper to safely map only if function exists
    local function safe_map(mode, lhs, rhs, opts)
      if rhs ~= nil then
        map(mode, lhs, rhs, opts)
      end
    end

    -- Buffer/File Navigation
    safe_map('n', '<leader>b',  fzf.buffers,   { desc = 'Buffers' })
    safe_map('n', '<leader>B',  '<cmd>ls<CR>:buffer<Space>', { desc = 'Buffer list (simple)' })
    safe_map('n', '<leader>ff', fzf.files,     { desc = 'Find files' })
    safe_map('n', '<leader>fr', fzf.oldfiles,  { desc = 'Recent files' })

    -- Search/Grep
    safe_map('n', '<leader>fg', fzf.live_grep,   { desc = 'Live grep' })
    safe_map('n', '<leader>fw', fzf.grep_cword,  { desc = 'Grep word under cursor' })
    safe_map('n', '<leader>fW', fzf.grep_cWORD,  { desc = 'Grep WORD under cursor' })
    safe_map('v', '<leader>fw', fzf.grep_visual, { desc = 'Grep visual selection' })
    safe_map('n', '<leader>f/', fzf.grep_curbuf, { desc = 'Grep current buffer' })
    safe_map('n', '<leader>fG', fzf.live_grep_resume, { desc = 'Live grep (resume)' })

    -- Git
    safe_map('n', '<leader>gf', fzf.git_files,    { desc = 'Git files' })
    safe_map('n', '<leader>gc', fzf.git_commits,  { desc = 'Git commits' })
    safe_map('n', '<leader>gC', fzf.git_bcommits, { desc = 'Git commits (buffer)' })
    safe_map('n', '<leader>gb', fzf.git_branches, { desc = 'Git branches' })
    safe_map('n', '<leader>gS', fzf.git_status,   { desc = 'Git status' })
    safe_map('n', '<leader>gt', fzf.git_stash,    { desc = 'Git stash' })

    -- LSP
    safe_map('n', '<leader>fs', fzf.lsp_document_symbols,  { desc = 'Document symbols' })
    safe_map('n', '<leader>fS', fzf.lsp_workspace_symbols, { desc = 'Workspace symbols' })
    safe_map('n', '<leader>fd', fzf.diagnostics_document,  { desc = 'Diagnostics (buffer)' })
    safe_map('n', '<leader>fD', fzf.diagnostics_workspace, { desc = 'Diagnostics (workspace)' })
    safe_map('n', '<leader>fi', fzf.lsp_implementations,   { desc = 'Implementations' })
    safe_map('n', '<leader>fR', fzf.lsp_references,        { desc = 'References' })

    -- Help & Vim
    safe_map('n', '<leader>fh', fzf.help_tags,       { desc = 'Help tags' })
    safe_map('n', '<leader>fk', fzf.keymaps,         { desc = 'Keymaps' })
    safe_map('n', '<leader>fc', fzf.commands,        { desc = 'Commands' })
    safe_map('n', '<leader>fC', fzf.command_history, { desc = 'Command history' })
    safe_map('n', '<leader>fm', fzf.marks,           { desc = 'Marks' })
    safe_map('n', '<leader>fj', fzf.jumps,           { desc = 'Jump list' })
    safe_map('n', '<leader>fq', fzf.quickfix,        { desc = 'Quickfix list' })
    safe_map('n', '<leader>fl', fzf.loclist,         { desc = 'Location list' })
    safe_map('n', '<leader>f"', fzf.registers,       { desc = 'Registers' })
    safe_map('n', '<leader>fa', fzf.autocmds,        { desc = 'Autocommands' })
    safe_map('n', '<leader>ft', fzf.filetypes,       { desc = 'Filetypes' })
    safe_map('n', '<leader>fo', fzf.vim_options,     { desc = 'Vim options' })

    -- Special
    safe_map('n', '<leader><leader>', fzf.resume,         { desc = 'Resume last picker' })
    safe_map('n', '<leader>f:', fzf.search_history,       { desc = 'Search history' })
    safe_map('n', '<leader>f.', fzf.builtin,              { desc = 'All pickers' })
    safe_map('n', '<leader>fL', fzf.lines,                { desc = 'Lines (all buffers)' })
    safe_map('n', '<leader>fb', fzf.blines,               { desc = 'Lines (buffer)' })

    vim.notify('fzf-lua loaded', vim.log.levels.INFO)
  end,
}
