-- this is from https://github.com/kdheepak/lazygit.nvim

return {
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        vim.notify('loading lazygit...', vim.log.levels.INFO)
        require("telescope").load_extension("lazygit")
    end,
}