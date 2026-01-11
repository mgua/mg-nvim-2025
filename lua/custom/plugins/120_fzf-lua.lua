-- 120_fzf-lua.lua
-- Lightning fast fuzzy finder for Neovim
-- https://github.com/ibhagwan/fzf-lua
--
-- Place in: lua/custom/plugins/120_fzf-lua.lua
--
-- KEYMAPS: <leader>b for buffers (fzf-lua)
--          <leader>f* uses Telescope (see 070_telescope.lua)
--
-- Prerequisites (Windows):
--   winget install junegunn.fzf
--   winget install sharkdp.fd              (optional, faster file finding)
--   winget install BurntSushi.ripgrep.MSVC (optional, faster grep)

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
    -- KEYMAPS - Only buffer navigation
    -- All <leader>f* keymaps are handled by Telescope (070_telescope.lua)
    -- ========================================================================
    local map = vim.keymap.set

    -- Buffer picker (fzf-lua's strength - very fast buffer switching)
    map('n', '<leader>b', fzf.buffers, { desc = 'Buffers (fzf)' })
    map('n', '<leader>B', '<cmd>ls<CR>:buffer<Space>', { desc = 'Buffer list (simple)' })

    -- ========================================================================
    -- OPTIONAL: Uncomment if you want fzf-lua for specific tasks
    -- (these use different prefixes to avoid telescope conflicts)
    -- ========================================================================
    
    -- Example: <leader>z* for fzf-lua specific features
    -- map('n', '<leader>zf', fzf.files,     { desc = 'fzf: Find files' })
    -- map('n', '<leader>zg', fzf.live_grep, { desc = 'fzf: Live grep' })
    -- map('n', '<leader>zr', fzf.resume,    { desc = 'fzf: Resume' })

    vim.notify('  fzf-lua loaded (buffers only)', vim.log.levels.INFO)
  end,
}
