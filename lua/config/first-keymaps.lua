-- keymaps.lua
-- Linux: ~/.config/nvim/lua/config/keymaps.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\keymaps.lua

-- this is invoked by init.lua, after the plugins have been loaded


local map = vim.keymap.set


-- Tabs & buffers
map("n", "<C-Left>", "<C-w>gT")    -- go to previous tab
map("n", "<C-Right>", "<C-w>gt")   -- go to next tab
map("n", "<C-Up>", ":bprev<CR>")   -- change current tab to previous buffer
map("n", "<C-Down>", ":bnext<CR>") -- change current tab to next buffer


-- this allows highlight of the yanked text in orange, for 250 ms
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



return {} -- Return empty table for module exports

