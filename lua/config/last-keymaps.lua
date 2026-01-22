-- last-keymaps.lua
-- Linux: ~/.config/nvim/lua/config/last-keymaps.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\last-keymaps.lua
--
-- this is invoked by init.lua, after the plugins have been loaded
--
-- to debug the keymap "g?" execute ":nmap g?" or ":verbose nmap g?"
--
-- leader key is defined in init.lua
--
-- NOTE: LSP keymaps are defined in 200_mason.lua (single source of truth)

local map = vim.keymap.set

vim.notify('  last-keymaps...', vim.log.levels.INFO)

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

-- File explorer keymaps
map('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'NvimTreeToggle' })
map('n', '<leader>t', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'NvimTreeToggle' })
map('n', '<leader>e', ':NvimTreeFocus<CR>', { noremap = true, silent = true, desc = 'NvimTreeFocus' })

-- LazyGit keymap
map('n', '<leader>gg', ':LazyGitCurrentFile<CR>', { noremap = true, silent = true, desc = 'LazyGit (currentFile)' })

-- Markdown Preview keymaps
map('n', '<leader>mp', ':MarkdownPreviewToggle<CR>', { noremap = true, silent = true, desc = 'MarkdownPreviewToggle' })

-- Startify keymaps
map('n', '<leader>ss', ':SSave<CR>', { noremap = true, silent = true, desc = 'Startify Save' })
map('n', '<leader>sl', ':SLoad<CR>', { noremap = true, silent = true, desc = 'Startify Load' })
map('n', '<leader>sd', ':SDelete<CR>', { noremap = true, silent = true, desc = 'Startify Delete' })
map('n', '<leader>sc', ':SClose<CR>', { noremap = true, silent = true, desc = 'Startify Close' })

-- NOTE: LSP keymaps (gd, gr, K, <leader>rn, <leader>ca, etc.) are in 200_mason.lua
-- Do not duplicate them here

-- Mergetool conflict navigation and resolution
map('n', '<leader>ml', '<cmd>diffget LOCAL<cr>', { desc = 'Get from LOCAL (left)' })
map('n', '<leader>mb', '<cmd>diffget BASE<cr>', { desc = 'Get from BASE (middle)' })
map('n', '<leader>mr', '<cmd>diffget REMOTE<cr>', { desc = 'Get from REMOTE (right)' })
map('n', '<leader>md', '<cmd>diffupdate REMOTE<cr>', { desc = 'Update diff markers highlights' })
map('n', ']c', ']c', { desc = 'Next conflict' })        -- default but desc is cool
map('n', '[c', '[c', { desc = 'Previous conflict' })    -- default but desc is cool


-- some keymaps are defined in 350_hex.lua hexedit/hexview plugin
--   <leader>h
--   <leader>h
--   <leader>h


-- some keymaps are defined in custom/plugins/050_gitsigns.lua: <leader>h[srSupb]
--   Stage|reset hunk, stage hunk|buffer, preview hunk, blame line


-- some keymaps are working by default, like
--      <CTRL><HOME> go to beginning
--      and
--      <CTRL><END> go to end of file

return {}
