-- lazy.lua (config/lazy)
-- Linux: ~/.config/nvim/lua/config/lazy.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\lazy.lua
--
-- the lazy.setup function expects a comma separated list for each plugin it has to install.
-- minimally this list contains a single element, which is the plugin name, expressed as string
-- possible other values are
--    lazy = true|false
--    priority = integervalue (100, 1000, ...)
--    event = 'string'
--    dependencies = list
--    config = function()   -- inside config function we may have a require('plugin-name').setup({...})
--    opts = { ... }
--    keys = { ... }
--    version =
--
--
-- other potentially interesting plugins: (see https://www.youtube.com/watch?v=f-G6kc1dzm0 )
-- folke/flash: https://github.com/folke/flash.nvim		fast movement (recommended)
-- j-hui/fidget
-- vimpostor/vim-tipipeline
-- norcalli/nvim-colorizer
-- christoomey/vim-tmux-navigator
-- nvim-treesitter/textobjects
-- abecodes/tabout
-- numToStr/Comment
-- Wansmer/treesj
-- windwp/nvim-autopairs
-- nvim-mini/mini.surround
--



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



{
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.icons"
    },
    config = function()
      require('fzf-lua').setup({
        fzf_bin = 'fzf',
        fzf_opts = {
          ['--layout'] = 'reverse',
          ['--info'] = 'inline',
          ['--header-lines'] = '0',       -- Don't treat any lines as header
          ['--no-header'] = '',           -- No header text
          ['--cycle'] = '',               -- Allow cycling through list
          ['--bind'] = 'ctrl-n:down,ctrl-p:up,ctrl-j:down,ctrl-k:up,tab:toggle+down',
        },
        buffers = {
          ignore_current_buffer = false,
          sort_lastused = true,
          fzf_opts = {
            ['--header-lines'] = '0',     -- Also set specifically for buffers
          },
        },
      })
      vim.keymap.set('n', '<leader>b', require('fzf-lua').buffers, { desc = 'Buffers' })
    end,
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


