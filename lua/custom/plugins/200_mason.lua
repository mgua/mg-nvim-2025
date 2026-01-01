-- this is the mason & related tools lazy config
-- this is where mason and related plugins are loaded, via lazy plugin manager lazy.lua
-- for other post setup configs see lua/configs/lsp.lua (invoked by init.lua)


return {

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
        vim.notify('loading mason...', vim.log.levels.INFO)	
        require('mason').setup()
    end
  },


  { -- mason-org/mason-lspconfig.mvim
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
  },

}


