-- easy-actions.lua for neovim
-- Linux: ~/.config/nvim/lua/config/easy-actions.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\easy-actions.lua
-- mgua@tomware.it 2026, tested with nvim 0.11
--
-- Settings to make neovim easier for users:
-- cursor selection, mouse, context menus, clipboard
-- (compatibility settings deprecated by purists)

local M = {}

-- Enable mouse support
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'popup_setpos'

-- Clipboard integration (use system clipboard)
vim.opt.clipboard = 'unnamedplus'

local map = vim.keymap.set

-- CUA-style clipboard keymaps
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
