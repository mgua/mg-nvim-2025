-- init.lua
-- Linux: ~/.config/nvim/init.lua
-- Windows: %LOCALAPPDATA%\nvim\init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
vim.g.mapleader = " "  -- Set leader key to space

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
vim.opt.mouse = 'a'

-- Load other configuration files
require("config.lazy")      -- Plugin management
require("config.keymaps")   -- Key mappings
require("config.languages") -- Language-specific settings