-- init.lua for neovim
-- Linux: ~/.config/nvim/init.lua -- Windows: %LOCALAPPDATA%\nvim\init.lua
-- mgua@tomware.it 2020-2025 last edit 31.12.2025, tested with nvim 0.11
-- this is the main init file for nvim. it is designed to be cross platform and 
-- to work for installations in different operating systems


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- this is based in %LOCALAPPDATA%/nvim-data/ or ~/.local/share/nvim/

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git","clone","--filter=blob:none","https://github.com/folke/lazy.nvim.git","--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings

vim.g.mapleader = " "       -- Set leader key to space
vim.g.maplocalleader = " "  -- Set leader key to space in every buf


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


-- List mode and listchars. for windows we assume that nerdfonts are 
-- available and correctly setup. Best experience for windows is within Microsoft Windows Terminal
vim.opt.list = true
vim.opt.listchars = {
    eol = "⏎",      -- Unicode for 'end of line'
    tab = "▸─",     -- Unicode for 'tab' (arrow and dash)
    trail = "·",    -- Unicode for 'trailing space'
    nbsp = "⎵",     -- Unicode for 'non-breaking space'
    space = "·"     -- Unicode for 'space'
}

-- Automatically send anything yanked to the default register (") to the system clipboard register (+).
-- this is draft and may require improvements/cross platform adjustments
if vim.fn.has('win32') == 1 then
	vim.opt.clipboard = 'unnamedplus'
else
	vim.opt.clipboard = 'unnamedplus'
end


require("config.keymaps")  -- Key mappings (lua/config/keymaps.lua)
require("config.lazy")     -- Plugins (lua/config/lazy.lua) including lua/custom/plugins/*.lua [in lazy format]
-- require("config.language") -- Language-specific settings (commented by mgua 29.9.2025)
require("config.colors") 	-- (lua/config/colors.lua) style colors consistent with vscode, loaded after plugins


-- this is the end of neovim init.lua
--
