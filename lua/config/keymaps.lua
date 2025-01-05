-- keymaps.lua
-- Linux: ~/.config/nvim/lua/config/keymaps.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\keymaps.lua

local map = vim.keymap.set
local osc = require('osc52')  -- This require is fine as it's a plugin

-- Normal mode mappings
map('n', '<leader>y', osc.copy_operator, {expr = true})
map('n', '<leader>yy', '<leader>y_', {remap = true})
map('n', '<leader>p', '"+p', { noremap = true })

-- Visual mode mappings
map('v', '<leader>y', osc.copy_visual)
map('v', '<leader>p', '"+p', { noremap = true })

-- File explorer keymaps
map('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
map('n', '<leader>e', ':NvimTreeFocus<CR>', { noremap = true, silent = true })

-- LazyGit keymap
map('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true })

-- Startify keymaps
map('n', '<leader>ss', ':SSave<CR>', { noremap = true, silent = true })
map('n', '<leader>sl', ':SLoad<CR>', { noremap = true, silent = true })
map('n', '<leader>sd', ':SDelete<CR>', { noremap = true, silent = true })
map('n', '<leader>sc', ':SClose<CR>', { noremap = true, silent = true })

-- LSP related keymaps
map('n', 'gd', vim.lsp.buf.definition, {})
map('n', 'gr', vim.lsp.buf.references, {})
map('n', 'K', vim.lsp.buf.hover, {})
map('n', '<leader>ca', vim.lsp.buf.code_action, {})
map('n', '<leader>rn', vim.lsp.buf.rename, {})

return {} -- Return empty table for module exports
