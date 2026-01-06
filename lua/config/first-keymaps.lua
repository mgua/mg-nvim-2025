-- first-keymaps.lua
-- Linux: ~/.config/nvim/lua/config/first-keymaps.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\first-keymaps.lua
--
-- this is invoked by init.lua, after the plugins have been loaded
--
-- to debug the keymap "g?" execute ":nmap g?" or ":verbose nmap g?"
--

local map = vim.keymap.set


-- Tabs & buffers
-- we avoid using CTRL being this often trapped by term emulators or multiplexers (tmux)
map("n", "[t", "gT", { desc = "Previous tab" })
map("n", "]t", "gt", { desc = "Next tab" })
map("n", "[b", "<cmd>bprev<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })

map("n", "èt", "gT", { desc = "Previous tab" })     -- for italian keyboard [
map("n", "+t", "gt", { desc = "Next tab" })         -- for italian keyboard ]
map("n", "èb", "<cmd>bprev<CR>", { desc = "Previous buffer" })  -- for italian key [
map("n", "+b", "<cmd>bnext<CR>", { desc = "Next buffer" })      -- for italian key ]

-- folds. there is a whole set of keys for controlling folding of text portions, like functions, markdown paragraph etc
-- typically fold operations are performed in normal or in visual mode
-- z key is the prefix for fold actions
-- fold metadata are stored


-- windows movement
map('n', '<C-h>', '<C-w>h')  -- move left
map('n', '<C-j>', '<C-w>j')  -- move down
map('n', '<C-k>', '<C-w>k')  -- move up
map('n', '<C-l>', '<C-w>l')  -- move right

map('i', '<C-w>', '<Nop>')          -- disable ctrl-w in insert mode
map('n', '<leader>w', '<C-w>w')     -- cycle windows with leader-w in normal mode

-- this allows highlight of the yanked text in orange, for 250 ms
-- see :help vi.highlight.on_yank() internal vim command
-- this is invoked by init.lua, after the plugins have been loaded
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({
            -- higroup = "IncSearch", -- dont know exactly what this is for
            timeout = 250,
            on_visual = true
        })
    end
})

-- to add special characters, consider the :digraph command
-- <CTRL-K>z'   ->  ź
-- <CTRL-K>u:   ->  ü
-- <CTRL-K>a>   ->  â

return {} -- Return empty table for module exports

