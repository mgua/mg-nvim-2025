-- easy-actions.lua for neovim
-- Linux: ~/.config/nvim/lua/config/easy-actions.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\easy-actions.lua
-- mgua@tomware.it 2026, tested with nvim 0.11
--
-- Settings to make neovim easier for users:
-- cursor selection, mouse, context menus, clipboard
-- (compatibility settings deprecated by purists)

local M = {}

-- Enable shift+cursor selection (CUA-style)
vim.opt.keymodel = 'startsel'
vim.opt.selectmode = 'key,mouse'

-- Enable mouse support
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'popup_setpos'

-- Clipboard integration (use system clipboard)
vim.opt.clipboard = 'unnamedplus'

local map = vim.keymap.set

-- CUA-style clipboard keymaps (visual mode)
map({ "n", "i" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })
map("v", "<C-c>", '"+y', { desc = "Copy" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
map("v", "<C-x>", '"+d', { desc = "Cut" })
map("v", "<C-Insert>", '"+y', { desc = "Copy (classic)" })
map({ "n", "i", "v", "c" }, "<S-Insert>", function()
  local mode = vim.fn.mode()
  if mode == "i" or mode == "c" then return "<C-r>+" end
  return '"+gP'
end, { expr = true, desc = "Paste (classic)" })

-- Select mode mappings (shift+cursor enters select mode due to selectmode setting)
-- These switch to visual mode so clipboard and leader keymaps work on the selection
map("s", "<C-c>", '<C-g>"+y', { desc = "Copy" })
map("s", "<C-x>", '<C-g>"+d', { desc = "Cut" })
map("s", "<C-Insert>", '<C-g>"+y', { desc = "Copy (classic)" })
map("s", "<S-Insert>", '<C-g>"+gP', { desc = "Paste (classic)" })
map("s", "y", '<C-g>"+y', { desc = "Yank selection" })
-- Leader in select mode: switch to visual so which-key shows copy options (c/C, y, etc.)
map("s", "<Space>", "<C-g><Space>", { desc = "Leader (which-key)" })

-- Save with Ctrl+S
map({ "n", "i", "v", "s" }, "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- ============================================================================
-- Right-click popup menu - DISABLED, using Neovim 0.11 built-in menu
-- Reference: TJ DeVries https://www.youtube.com/watch?v=_U54QKdFQno
-- ============================================================================
--[[
vim.cmd [[
  aunmenu PopUp
  anoremenu PopUp.Cut         "+x
  anoremenu PopUp.Copy        "+y
  anoremenu PopUp.Paste       "+gP
  anoremenu PopUp.-1-         <NOP>
  anoremenu PopUp.Inspect     <cmd>Inspect<CR>
  anoremenu PopUp.Definition  <cmd>lua vim.lsp.buf.definition()<CR>
  anoremenu PopUp.References  <cmd>Telescope lsp_references<CR>
  anoremenu PopUp.Back        <C-t>
  anoremenu PopUp.-2-         <NOP>
  anoremenu PopUp.URL         gx
] ]
--]]

return M
