-- this is from https://github.com/nvim-treesitter/nvim-treesitter
-- treesitter plugin loader, for lazy plugin manager
--
-- how do you know if Treesitter is active in your current buffer?
--    try to see via command mode if TS<tab> shows an adequate number of options (5 options is not ok)
--    try to use  :Inspect while cursor is on some keyword
--    try         :TSInstall yourlanguage
--    you can launch treesitter in the current buffer with
--                :lua vim.treesitter.start()

return {
    -- treesitter https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file
    -- windows prerequirements: winget install Microsoft.VisualStudio.2022.BuildTools OR winget install zig.zig
    -- winget install  OpenJS.NodeJS.LTS
    -- npm install -g tree-sitter-cli
    -- linux prerequirements: apt install build-essentials
    -- git tar curl node.js
    'nvim-treesitter/nvim-treesitter',
    lazy = false,    -- treesitter plugin does not support lazy-loading
    build = ':TSUpdate',

    priority = 100, -- load before other plugins
    -- event = {'BufReadPost', 'BufNewFile' },
    -- dependencies = {
    --    'nvim-treesitter/nvim-treesitter-textobjects',             -- Optional but very useful
    --    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- },--
    --
    --
    --  QUESTO STRONXZO NON FUNZIONA
    --
    config = function()
        vim.notify('loading treesitter...', vim.log.levels.INFO)
        myparsers = { "lua","python","vim","vimdoc","powershell","bash","markdown","json","yaml"}
        require('nvim-treesitter').install(myparsers)
        vim.api.nvim_create_autocmd('FileType', {
          pattern = myparsers,
          callback = function() vim.treesitter.start() end,
        })
    end,
}




