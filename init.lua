<<<<<<< HEAD
-- init.lua for neovim
-- Linux: ~/.config/nvim/init.lua
-- Windows: %LOCALAPPDATA%\nvim\init.lua
-- mgua@tomware.it 2020-2025
-- last edit 24.12.2025

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- this is based in %LOCALAPPDATA%/nvim-data/ or ~/.local/share/nvim/
=======
-- init.lua
-- Linux: ~/.config/nvim/init.lua
-- Windows: %LOCALAPPDATA%\nvim\init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
>>>>>>> ba2ad6c089e920c38f3f396b465b121595d74815
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings
<<<<<<< HEAD
vim.g.mapleader = " "       -- Set leader key to space
vim.g.maplocalleader = " "  -- Set leader key to space in every buf
=======
vim.g.mapleader = " "  -- Set leader key to space
>>>>>>> ba2ad6c089e920c38f3f396b465b121595d74815

-- Tmux settings
vim.opt.termguicolors = true
if vim.env.TMUX then
  vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard in tmux
  vim.opt.term = "xterm-256color"    -- Better color support in tmux
  vim.opt.timeoutlen = 1000
  vim.opt.ttimeoutlen = 0
end

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
<<<<<<< HEAD
vim.opt.autoindent = true
vim.opt.scrolloff = 4
vim.opt.wrap = false -- equivalent to set nowrap

vim.opt.mouse = 'a' -- Mouse support

vim.env.LANG = 'en_US.UTF-8'
vim.env.LC_ALL = 'en_US.UTF-8'  -- needed on linux
vim.opt.encoding = "UTF-8" -- default Encoding

-- python venv dedicated to neovim: venv_neovim, in user home folder
-- on win create with py -3.12-m venv venv_neovim and install pynvim and neovim
if vim.fn.has('win32') == 1 then
  vim.g.python3_host_prog = vim.env.USERPROFILE .. '/venv_neovim/Scripts/python.exe'
else
  vim.g.python3_host_prog = vim.env.HOME .. '/venv_neovim/bin/python'
end


-- List mode and listchars
vim.opt.list = true
vim.opt.listchars = {
    eol = "⏎",      -- Unicode for 'end of line'
    tab = "▸─",     -- Unicode for 'tab' (arrow and dash)
    trail = "·",    -- Unicode for 'trailing space'
    nbsp = "⎵",     -- Unicode for 'non-breaking space'
    space = "·"     -- Unicode for 'space'
}

-- Automatically send anything yanked to the default register (") to the system clipboard register (+).
vim.opt.clipboard = 'unnamedplus'

require("config.keymaps")   -- Key mappings
require("config.lazy")      -- Plugin management
-- require("config.languages") -- Language-specific settings (commented by mgua 29.9.2025)
require("config.colors") -- colors consistent with vscode, loaded after plugins


-- this is the end of init.lua
--
=======
vim.opt.mouse = 'a'

-- Load other configuration files
require("config.lazy")      -- Plugin management
require("config.keymaps")   -- Key mappings
require("config.languages") -- Language-specific settings
>>>>>>> ba2ad6c089e920c38f3f396b465b121595d74815
