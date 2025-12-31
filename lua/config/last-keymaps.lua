-- mgua: here are my additional keymaps
-- this file is to be loaded last after all the plugins heve been processed
--
-- .o. / .wo. ecc are the "scopes"
-- .o. is the general settings
-- .wo. are the windows scoped options
-- .bo. are the buffer scope
-- see https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

local map = vim.keymap.set

local osc = require('osc52')  -- This require is fine as it's a plugin not required anymore on windows

-- ----------------- COPY to clipboard ----------------------
if vim.fn.has('win32') == 1 then
  -- Normal mode mappings
  map('n', '<leader>y', osc.copy_operator, {expr = true, desc = 'osc.copy normalmode' })
  map('n', '<leader>yy', '<leader>y_', {remap = true, desc = 'yank to _' })
  map('n', '<leader>C', '"+yy', { desc = 'Copy line to clipboard' })
  map('n', '<leader>c', '"+yy', { desc = 'Copy line to clipboard' })

-- Visual mode mappings
  map('v', '<leader>y', osc.copy_visual, { desc = 'osc.copy visual mode' })
  map('v', '<leader>yy', '<leader>y_', {remap = true, desc = 'yank to _' })
  map('v', '<leader>C', '"+y', { desc = 'Copy selection to clipboard' })
  map('v', '<leader>c', '"+y', { desc = 'Copy selection to clipboard' })

else	-- non windows
-- see https://github.com/ojroques/nvim-osc52 (mgua sept 9 2023)
-- allows copy from nvim buffers to osc52 compatible terminal emulator system clipboard
  map('n', '<leader>y', require('osc52').copy_operator, {expr = true, desc = 'osc.copy normalmode' })
  map('n', '<leader>yy', '<leader>y_', {remap = true, desc = 'yank to _' })
  map('n', '<leader>C', '"+yy', { desc = 'Copy line to clipboard' })
  map('n', '<leader>c', '"+yy', { desc = 'Copy line to clipboard' })
  
  map('v', '<leader>y', require('osc52').copy_visual, {expr = true, desc = 'osc.copy visual mode' })
  map('v', '<leader>yy', '<leader>y_', {remap = true, desc = 'yank to _' })
  map('v', '<leader>C', '"+y', { desc = 'Copy selection to clipboard' })
  map('v', '<leader>c', '"+y', { desc = 'Copy selection to clipboard' })
end

-- old version:
-- map('n', '<leader>c', require('osc52').copy_operator, {expr = true})
-- map('n', '<leader>cc', '<leader>c_', {remap = true})
-- map('v', '<leader>c', require('osc52').copy_visual)

-- File explorer keymaps
map('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'NvimTreeToggle' })
map('n', '<leader>t', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'NvimTreeToggle' })
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

-- map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Action' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP ReName' })


return {}
