-- init.lua for neovim
-- Linux: ~/.config/nvim/initflua -- Windows: %LOCALAPPDATA%\nvim\init.lua
-- mgua@tomwame.it 2020-2025 last edit 31.12.2025, tested with nvim 0.11
-- this is the main init file for nvim. it is designed to be cross platform and
-- to work for installations in different operating systems

-- IMPORTANT. a current standard for editor configuration is .editorconfig
-- a hidden .editorconfig file holds important settings for encoding,
-- line ending, tab lenght, whitespace management, tab processing

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- this is based in %LOCALAPPDATA%/nvim-data/ or ~/.local/share/nvim/

if not vim.uv.fs_stat(lazypath) then -- was "if not vim.loop.fs_stat(lazypath) then" before jan 19 2026
  vim.fn.system({
    "git","clone","--filter=blob:none","https://github.com/folke/lazy.nvim.git","--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- enable deprecation warning for config checkup
vim.g.deprecation_warnings = true

-- Basic settings

vim.g.mapleader = " "       -- Set leader key to space
vim.g.maplocalleader = " "  -- Set leader key to space in every buf


-- Tmux settings
vim.opt.termguicolors = true
if vim.env.TMUX then
  vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard in tmux
  -- vim.opt.term = "xterm-256color"    -- Better color support in tmux: commented out on jan 19 2026 because of error
  vim.opt.timeoutlen = 1000
  vim.opt.ttimeoutlen = 0
end

vim.opt.timeoutlen = 1000           -- Affects folke/which-key and numToStr/Comment.nvim

-- General settings
-- these are equivalent to vim.cmd syntax (vim style) as:
-- vim.cmd [[
--  set cc=90 " column where to put vertical bar
--  set shiftwidth=4
-- ]]

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.scrolloff = 4
vim.opt.wrap = false -- equivalent to set nowrap

vim.opt.mouse = 'a' -- Mouse support

vim.env.LANG = 'en_US.UTF-8'
vim.env.LC_ALL = 'en_US.UTF-8'    -- needed on linux
-- vim.opt.encoding = "UTF-8"        -- default Encoding  (not needed default, commented on jan 19 2026)

-- =============================================================================
-- Basic Syntax, Folding and Indentation (fallback for non-treesitter filetypes)
-- These are overridden by treesitter for supported filetypes (see 100_treesitter.lua)
-- =============================================================================
vim.opt.syntax = "on"           -- Basic regex-based syntax highlighting
vim.opt.foldmethod = "indent"   -- Fold based on indentation
vim.opt.foldlevel = 99          -- Start with all folds open
vim.opt.autoindent = true       -- Copy indent from current line to new line
vim.opt.smartindent = true      -- Smart autoindenting for C-like languages


 -- from checkhealth suggestion, to remove warnings
-- opts.rocks.hererocks = false
-- opts.rocks.enabled = false
-- these settings are to be placed in lazy.lua
-- when checkhealth says opts.rocks.enabled = false, it means:
--      require('lazy').setup(
--        { --[[ plugins list ]] },
--        { rocks = { enabled = false } }  -- this is "opts"
--      )--


-- python venv dedicated to neovim: venv_neovim, in user home folder
-- on win create with py -3.12-m venv venv_neovim and install pynvim and neovim
if vim.fn.has('win32') == 1 then
  vim.g.python3_host_prog = vim.env.USERPROFILE .. '/venv_neovim/Scripts/python.exe'
else
  vim.g.python3_host_prog = vim.env.HOME .. '/venv_neovim/bin/python'
end

-- List mode and listchars. for windows we assume that nerdfonts are available
-- and correctly setup. Best experience for windows is within Microsoft Windows Terminal
vim.opt.list = true
vim.opt.listchars = {
    eol = "⏎",      -- Unicode for 'end of line'
    tab = "»─",     -- Unicode for 'tab' (arrow and dash) alternative: » (Right-Pointing Double Angle Quotation Mark U+00BB)
    trail = "·",    -- Unicode for 'trailing space'
    nbsp = "⎵",     -- Unicode for 'non-breaking space'
    space = "·"     -- Unicode for 'space'
}
-- vim.opt.listchars = {eol = '\\u23ce', tab = '\\u25b8\\u2500', trail = '\\u00b7', space = '\\u00b7', nbsp = '\\u23b5'}

-- Automatically send anything yanked to the default register (") to the system clipboard register (+).
-- this is draft and may require improvements/cross platform adjustments
if vim.fn.has('win32') == 1 then
  vim.opt.clipboard = 'unnamedplus'
else
  vim.opt.clipboard = 'unnamedplus'
end

require("config.easy-actions")    -- (lua/config/easy-actions.lua) user friendly selections and mouse
require("config.venv-selector")   -- (lua/config/venv-selector.lua) selects correct python venv
require("config.first-keymaps")   -- Key mappings (lua/config/first-keymaps.lua)
require("config.lazy")            -- Plugins (lua/config/lazy.lua) including lua/custom/plugins/*.lua [in lazy format]
require("config.colors")          -- (lua/config/colors.lua) style colors consistent with vscode, loaded after plugins
require("config.lsp")             -- (lua/config/lsp.lua) mason/lsp configs [post load]
require("config.last-keymaps")    -- (lua/config/last-keymaps.lua) final keymaps [post load]


-- this is the end of neovim init.lua
--
