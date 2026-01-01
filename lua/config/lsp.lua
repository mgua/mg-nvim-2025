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
        local bufopts = { noremap = true, silent = true, buffer = ev.buf }

        -- Common LSP keymaps
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format({ async = true })
        end, bufopts)
    end,
})



--- Optional: Server-specific configurations ---
-- If you need custom settings for specific servers, configure them here:
local lspconfig = require('lspconfig')
lspconfig.sqls.setup({
     -- custom sqls settings (or use .sqls.yml in project root)
})


-- You can manually add a basic setup here, but `mason-lspconfig.setup_handlers` 
-- above is the modern way to handle this. 
-- The setup above is sufficient! 

print("LSP configuration loaded.")

