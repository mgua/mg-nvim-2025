-- lazy.lua (config/lazy)
-- Linux: ~/.config/nvim/lua/config/lazy.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\lazy.lua

return require('lazy').setup({
  -- UI Enhancements
  { 'nvim-tree/nvim-web-devicons', lazy = false,  },
    --  { 'folke/lazy.nvim', version = false },
    --  { 'LazyVim/LazyVim', version = false },


  { -- adds a small square next to hex color codes
    'brenoprata10/nvim-highlight-colors',
    config = function()
      require('nvim-highlight-colors').setup({
        render = 'virtual',
        virtual_symbol = '■',
        virtual_symbol_position = 'inline',  -- 'eol' or 'inline'
        exclude_filetypes = { 'xxd' },       -- disable for hex editing (added by mgua jan 04 2026)
      })
    end
  },

  { vim.notify('executing lazy.lua...', vim.log.levels.INFO) },

  { 'christoomey/vim-tmux-navigator', lazy = false, },  -- Tmux Integration

  { 'echasnovski/mini.icons', version = false },  -- mini icons see https://github.com/echasnovski/mini.icons

  
  -- File Explorer: see nvim-tree in custom/plugins
  -- tresitter: see in custom/plugins
  -- mason: see in custom/plugins
  -- startify: see in custom/plugins
  

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
        triggers = {{ "<leader>", mode = { "n", "v" } },}    -- normal and visual mode
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

  -- and now proceed to import all the custom/plugins/*.lua plugins (in lazy format)
  { import = 'custom.plugins' }, 

})
