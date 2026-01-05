-- easy-actions.lua for neovim
-- Linux: ~/.config/nvim/lua/config/easy-actions.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\easy-actions.lua
-- mgua@tomware.it 2026, tested with nvim 0.11
--
-- Settings to make neovim easier for users:
-- cursor selection, mouse, context menus, clipboard
-- (compatibility settings deprecated by purists)

local M = {}

-- Enable traditional shift+cursor selection
vim.opt.keymodel = 'startsel,stopsel'
vim.opt.selectmode = 'key,mouse'

-- Enable mouse support
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'popup_setpos'

-- Clipboard integration (use system clipboard)
vim.opt.clipboard = 'unnamedplus'

-- Convenient keymaps for selection/clipboard
-- CTRL+A select all (insert and normal mode)
vim.keymap.set({'n', 'i'}, '<C-a>', '<Esc>ggVG', { desc = 'Select all' })

-- CTRL+C copy in visual mode
vim.keymap.set('v', '<C-c>', '"+y', { desc = 'Copy to clipboard' })

-- CTRL+V paste (insert mode) - careful: conflicts with visual block in normal
vim.keymap.set('i', '<C-v>', '<C-r>+', { desc = 'Paste from clipboard' })

-- CTRL+X cut in visual mode
vim.keymap.set('v', '<C-x>', '"+d', { desc = 'Cut to clipboard' })

-- Classic CUA/X11 clipboard shortcuts
-- CTRL+Insert copy (visual mode)
vim.keymap.set('v', '<C-Insert>', '"+y', { desc = 'Copy to clipboard (classic)' })

-- SHIFT+Insert paste (normal, insert, visual, command modes)
vim.keymap.set('n', '<S-Insert>', '"+gP', { desc = 'Paste from clipboard (classic)' })
vim.keymap.set('i', '<S-Insert>', '<C-r>+', { desc = 'Paste from clipboard (classic)' })
vim.keymap.set('v', '<S-Insert>', '"+gP', { desc = 'Paste from clipboard (classic)' })
vim.keymap.set('c', '<S-Insert>', '<C-r>+', { desc = 'Paste from clipboard (classic)' })

-- SHIFT+Delete cut (visual mode) - bonus classic shortcut
vim.keymap.set('v', '<S-Delete>', '"+d', { desc = 'Cut to clipboard (classic)' })

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
