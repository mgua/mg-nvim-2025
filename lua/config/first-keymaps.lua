-- first-keymaps.lua
-- Linux: ~/.config/nvim/lua/config/first-keymaps.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\first-keymaps.lua

-- this is invoked by init.lua, after the plugins have been loaded


local map = vim.keymap.set


-- Tabs & buffers
-- we avoid using CTRL being this often trapped by term emulators or multiplexers (tmux)
map("n", "[t", "gT", { desc = "Previous tab" })
map("n", "]t", "gt", { desc = "Next tab" })
map("n", "[b", "<cmd>bprev<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- windows movement
map('n', '<C-h>', '<C-w>h')  -- move left
map('n', '<C-j>', '<C-w>j')  -- move down
map('n', '<C-k>', '<C-w>k')  -- move up
map('n', '<C-l>', '<C-w>l')  -- move right

map('i', '<C-w>', '<Nop>')  -- disable ctrl-w in insert mode


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



return {} -- Return empty table for module exports

