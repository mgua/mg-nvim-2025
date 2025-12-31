-- mgua: here are my additional keymaps
-- this file is to be loaded last after all the plugins heve been processed
--
-- .o. / .wo. ecc are the "scopes"
-- .o. is the general settings
-- .wo. are the windows scoped options
-- .bo. are the buffer scope
-- see https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/


-- i want to make <leader>tt to toggle nvtree
-- vim.keymap.set("n", "<leader>tt", ":NvimTreeToggle<Enter>")
-- vim.keymap.set("n", "<leader>r", ":%s/<C-r><C-w>//g<Left><Left>")

vim.keymap.set("n", "<C-Left>", "<C-w>gT")    -- go to previous tab
vim.keymap.set("n", "<C-Right>", "<C-w>gt")   -- go to next tab
vim.keymap.set("n", "<C-Up>", ":bprev<CR>")   -- change current tab to previous buffer
vim.keymap.set("n", "<C-Down>", ":bnext<CR>") -- change current tab to next buffer

-- see https://github.com/ojroques/nvim-osc52 (mgua sept 9 2023)
-- allows copy from nvim buffers to osc52 compatible terminal emulator system clipboard
vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)


return {}
