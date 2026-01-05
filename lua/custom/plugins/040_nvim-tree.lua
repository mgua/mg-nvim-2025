-- this is from https://github.com/nvim-tree/nvim-tree.lua
-- requires neovim 0.9+
-- requires nerdfont

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons", },
  config = function()
	vim.g.loaded_netrw = 1	-- disabling netrw is recommended!!
		-- https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
	vim.g.loaded_netrwPlugin = 1
	vim.notify('loading nvim-tree...', vim.log.levels.INFO)
	require("nvim-tree").setup({
		sort = { sorter = "case_sensitive", },
		view = { width = 30, },
		renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
          },
        },
		filters = { 
            dotfiles = false,       -- if false dotfiles are shown
            git_ignored = false,    -- if false .gitignore files are shown
            custom = { ".git", "__pycache__" }, -- always hide these
            exclude = { ".env" },   -- never filter: always show these
        },
        git = {
            enable = true,          -- enable git integration
            ignore = false,         -- do not respect .gitignore (do not hide gitignored files)
            show_on_dirs = true,    -- show git status on directories
            show_on_open_dirs = true,   -- directory keeps its git icon when expanded
            timeout = 400,          -- git operation timeout in ms
        },
		})
  end,
}
