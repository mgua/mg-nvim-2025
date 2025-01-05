-- keymaps.lua
-- Linux: ~/.config/nvim/lua/config/keymaps.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\keymaps.lua

local map = vim.keymap.set
local osc = require('osc52')  -- This require is fine as it's a plugin

-- this allows highlight of the yanked text 
-- see :help vi.highlight.on_yank() internal vim command
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({
            -- higroup = "IncSearch", -- dont know exactly what this is for
            timeout = 250,
            on_visual = true
        })
    end
})

-- Normal mode mappings
map('n', '<leader>y', osc.copy_operator, {expr = true, desc = 'osc.copy normalmode' })
map('n', '<leader>yy', '<leader>y_', {remap = true, desc = 'yank to _' })
map('n', '<leader>p', '"+p', { noremap = true, desc = '"+p (dontknow) })

-- Visual mode mappings
map('v', '<leader>y', osc.copy_visual, desc = 'osc.copy visual mode')
map('v', '<leader>p', '"+p', { noremap = true, desc = '"+p (dontknow)' })

-- File explorer keymaps
map('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'NvimTreeToggle' })
map('n', '<leader>e', ':NvimTreeFocus<CR>', { noremap = true, silent = true, desc = 'NvimTreeFocus' })

-- LazyGit keymap
map('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true, desc = 'LazyGit' })

-- Markdown Preview keymaps
map('n', '<leader>mp', ':MarkdownPreviewToggle<CR>', { noremap = true, silent = true, desc = 'MarkdownPreviewToggle' })

-- Startify keymaps
map('n', '<leader>ss', ':SSave<CR>', { noremap = true, silent = true, desc = 'Startify Save' })
map('n', '<leader>sl', ':SLoad<CR>', { noremap = true, silent = true, desc = 'Startify Load' })
map('n', '<leader>sd', ':SDelete<CR>', { noremap = true, silent = true, desc = 'Startify Delete' })
map('n', '<leader>sc', ':SClose<CR>', { noremap = true, silent = true, desc = 'Startify Close' })

-- LSP related keymaps
map('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP goto Definition' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'LSP goto References' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'LSP hover Documentation' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Action' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP ReName' })

return {} -- Return empty table for module exports
