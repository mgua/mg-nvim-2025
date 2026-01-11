-- lsp.lua
-- this neovim lsp.lua file contains configurations for mason/LSP
-- this is invoked by init.lua, after the plugins have been loaded

vim.notify('lsp.lua additional setup...', vim.log.levels.INFO)

-- Suppress lspconfig deprecation warnings until mason-lspconfig updates
-- mgua added this (suggested by claude opus on jan 01 2026)
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("lspconfig") and msg:match("deprecated") then return end
  notify(msg, ...)
end


-- --- Setup Mason & mason-lspconfig ---
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'sqls' },
    automatic_enable = true,  -- automatically sets up installed LSP servers
})

-- --- LSP Keymaps via LspAttach autocmd ---
-- This is the modern way to set up LSP keymaps (works with mason-lspconfig v2.x)
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { noremap = true, silent = true, buffer = ev.buf }

        opts.desc = "Go to Declaration"
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

        opts.desc = "Go to Definition"
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

        opts.desc = "Hover Documentation"
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

        opts.desc = "Go to Implementation"
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

        opts.desc = "Rename Symbol"
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

        opts.desc = "Code Action"
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

        opts.desc = "Find References"
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        opts.desc = "Previous Diagnostic"
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)

        opts.desc = "Next Diagnostic"
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

        opts.desc = "Format Code" -- changed from f to lf for conflicts with telescope 
        vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, opts)

    end,
})



--- Optional: Server-specific configurations, with .sqls.yml in project root ---
--[[
# .sqls.yml template
# put such a file in your project root, with credentials. this will be used by sqls LSP server
#

connections:
  - alias: postgres_dev
    driver: postgresql
    data_source_name: postgresql://user:password@host:port/dbname?sslmode=disable
    # For your PostgreSQL connection

  - alias: mariadb_dev
    driver: mysql
    data_source_name: user:password@tcp(host:port)/dbname
    # For your MariaDB/MySQL connection

  - alias: mssql_dev
    driver: mssql
    data_source_name: sqlserver://user:password@host:port?database=dbname
    # For your MSSQL/SQL Server connection

# 'driver' must be 'postgresql', 'mysql', 'mssql', etc.
--]]

local lspconfig = require('lspconfig')
-- lspconfig.sqls.setup({
--      -- custom sqls settings (or use .sqls.yml in project root see .sqls.yml.template)
-- })



print("LSP configuration loaded.")

