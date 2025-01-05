-- lazy.lua
-- Linux: ~/.config/nvim/lua/config/lazy.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\lazy.lua

return require('lazy').setup({
  -- UI Enhancements
  { 'nvim-tree/nvim-web-devicons', lazy = false,  },
    --  { 'folke/lazy.nvim', version = false },
    --  { 'LazyVim/LazyVim', version = false },

  
  -- File Explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
      })
    end
  },

  -- Tmux Integration
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
  },

  -- Git Integration
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '│' },
          change = { text = '│' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})
          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})
          -- Actions
          map('n', '<leader>hs', gs.stage_hunk)
          map('n', '<leader>hr', gs.reset_hunk)
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line{full=true} end)
        end
      })
    end
  },

  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  -- Core plugins
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "python", "lua" },
        highlight = { enable = true },
      })
    end
  },

  -- LSP Support
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  },

  -- Clipboard support
  {
    'ojroques/nvim-osc52',
    config = function()
      require('osc52').setup {
        max_length = 0,  -- Maximum length of selection (0 for no limit)
        silent = false,  -- Disable message on successful copy
        trim = false,    -- Trim surrounding whitespaces before copy
      }
    end
  },

  -- Start Screen
  {
    'mhinz/vim-startify',
    config = function()
      -- Custom header
      -- vim.g.startify_custom_header = {
      --  '   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
      --  '   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
      --  '   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
      --  '   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
      --  '   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
      --  '   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
      -- }
      
      -- Configure session directory
      vim.g.startify_session_dir = vim.fn.stdpath('data')..'/session'
      
      -- Custom lists
      vim.g.startify_lists = {
        { type = 'files',     header = {'   Recent Files'}},
        { type = 'sessions',  header = {'   Sessions'}},
        { type = 'bookmarks', header = {'   Bookmarks'}},
      }
      
      -- Custom bookmarks
      vim.g.startify_bookmarks = {
        { c = '~/.config/nvim/init.lua' },
        { p = '~/projects' },
      }
      
      -- Other settings
      vim.g.startify_session_autoload = 1    -- Automatically load session if one exists
      vim.g.startify_session_persistence = 1  -- Automatically update sessions
      vim.g.startify_change_to_vcs_root = 1  -- Change to project root
      vim.g.startify_fortune_use_unicode = 1  -- Use Unicode box drawing characters
      vim.g.startify_enable_special = 0      -- Don't show <empty buffer> and <quit>
    end
  },

  -- Markdown Preview
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ''  -- Use default browser
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_page_title = '「${name}」'
    end,
  },

  {
	-- WhichKey is a useful plugin for Neovim 0.5 that displays a popup with possible key bindings 
	-- of the command you started typing.
    "folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
	  vim.o.timeout = true
	  vim.o.timeoutlen = 300
	end,
	opts = {
    	-- your configuration comes here
    	-- or leave it empty to use the default settings
    	-- refer to the configuration section below
	}
  },


  -- Theme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd[[colorscheme tokyonight]]
    end,
  },
})
