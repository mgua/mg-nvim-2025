-- lazy.lua (config/lazy)
-- Linux: ~/.config/nvim/lua/config/lazy.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\lazy.lua

return require('lazy').setup({
  -- UI Enhancements
  { 'nvim-tree/nvim-web-devicons', lazy = false,  },
    --  { 'folke/lazy.nvim', version = false },
    --  { 'LazyVim/LazyVim', version = false },

  { vim.notify('executing lazy.lua...', vim.log.levels.INFO) },
  
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

  { 'christoomey/vim-tmux-navigator', lazy = false, },  -- Tmux Integration


  {  -- Git Integration
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


  { 'kdheepak/lazygit.nvim', dependencies = { 'nvim-lua/plenary.nvim', }, },


  { -- treesitter https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file
    -- windows prerequirements: winget install Microsoft.VisualStudio.2022.BuildTools OR winget install zig.zig
    -- winget install  OpenJS.NodeJS.LTS
    -- npm install -g tree-sitter-cli
    -- linux prerequirements: apt install build-essentials
    -- git tar curl node.js
    'nvim-treesitter/nvim-treesitter',
    lazy = false,    -- treesitter plugin does not support lazy-loading
    build = ':TSUpdate',

    priority = 100, -- load before other plugins
    -- event = {'BufReadPost', 'BufNewFile' },
    -- dependencies = {   
    --    'nvim-treesitter/nvim-treesitter-textobjects',             -- Optional but very useful
    --    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- },
    config = function()
        require('nvim-treesitter').setup({
            -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
            install_dir = vim.fn.stdpath('data') .. '/site',
            -- require('nvim-treesitter').install({ 'rust', 'javascript', 'zig' }):wait(300000) -- wait max. 5 minutes
            ensure_installed = { "python", "lua", "vim", "vimdoc", "bash", "powershell", "markdown", "json", "yaml",  },
            sync_install = false,  -- Install parsers synchronously (only applied to `ensure_installed`)
            auto_install = true,   -- Automatically install missing parsers when entering buffer
            -- ignore_install = {},   -- List of parsers to ignore installing (for "all")
            highlight = { 
                enable = true, 
                -- disable = function(lang, buf)
                --    local max_filesize = 100 * 1024 -- 100 KB
                --   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                --    if ok and stats and stats.size > max_filesize then
                --        return true
                --    end
                -- end,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true, },
            -- incremental_selection = {
            -- enable = true,
            -- keymaps = {
            --        init_selection = '<C-space>', node_incremental = '<C-space>',
            --        scope_incremental = false, node_decremental = '<bs>',
            --    },
            -- },
        })
    end,
  },


  { -- core component to allow nvim to use LSP servers
    -- mason can not work without this
    'neovim/nvim-lspconfig',
  },


  { -- mason https://github.com/mason-org/mason.nvim
    -- requires git, curl/wget , unzip, gzip, tar  
    'mason-org/mason.nvim',
    build = ':MasonUpdate', -- build/updates extension catalog for :MasonInstall
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    },
    config = function()
        require('mason').setup()
    end
  },


  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
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


  {
  -- Markdown Preview you need npm and yarn
  -- windows: winget install  OpenJS.NodeJS.LTS
  --          npm install -g yarn 
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      if vim.fn.has('win32') == 1 then
          vim.fn.system('cmd.exe /c "cd app && npm install"')
      else
          vim.fn.system('cd app && npm install')
      end
    end,    

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
    "folke/which-key.nvim",
	-- WhichKey is a useful plugin that displays a popup with possible key bindings 
	-- of the command you started typing. https://github.com/folke/which-key.nvim
	event = "VeryLazy",
    --	init = function()
	--  vim.o.timeout = true
	--  vim.o.timeoutlen = 300
	--end,
	opts = {
    	-- your configuration comes here
    	-- or leave it empty to use the default settings
    	-- refer to the configuration section below
            triggers = {
                { "<leader>", mode = { "n", "v" } },    -- normal and visual mode
            }
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
  },


  {
    "ibhagwan/fzf-lua",
    -- lightning fast search for files
    -- https://github.com/ibhagwan/fzf-lua
    dependencies = { 
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.icons"
    },
    opts = {}
  },


  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- mini icons see https://github.com/echasnovski/mini.icons
  { 'echasnovski/mini.icons', version = false },


  {  -- Theme
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd[[colorscheme tokyonight]]
    end,
  },

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 100,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

})
