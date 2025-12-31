-- lsp.lua
-- this neovim lsp.lua file contains configurations for mason/LSP
-- this is invoked by init.lua, after the plugins have been loaded

vim.notify('lsp.lua additional setup...', vim.log.levels.INFO)

local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')

-- --- Setup Mason & lspconfig ---
-- This handler automatically sets up any language server installed by Mason.
-- We use it here primarily for 'sqls'.
mason_lspconfig.setup_handlers {
    function(server_name)
        -- Set keymaps for common LSP actions
        local on_attach = function(client, bufnr)
            -- See :help vim.lsp.buf for a list of functions
            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            
            -- Examples of common LSP keymaps
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
        end

        -- Call setup for the server. 
        -- If the server is 'sqls', any project-specific settings 
        -- will usually be read from a local .sqls.yml file.
        lspconfig[server_name].setup {
            on_attach = on_attach,
            -- Add more global server options here if needed, 
            -- but for 'sqls' it's often best to use the .sqls.yml file.
        }
    end,
}

-- --- Ensure `sqls` is managed by Mason ---
-- This makes sure that 'sqls' is in Mason's list of managed LSPs 
-- and will be installed if you run :Mason
require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = { 'sqls' },
}

-- You can manually add a basic setup here, but `mason-lspconfig.setup_handlers` 
-- above is the modern way to handle this. 
-- The setup above is sufficient! 

print("LSP configuration loaded.")

