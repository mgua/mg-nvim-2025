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
    --
    -- see :help nvim-treesitter.txt
    -- CAUTION: on github, the treesitter repo has the "old" master branch which is not (jan 2026) legacy. new
    -- code is in the main branch, but it is a full rewrite, and documentation is not updated. TJ Devries video
    -- is specific for the now legacy version
    -- here we try to make the new version working, but configurations apparently have to be adapted
    --
    --
    'nvim-treesitter/nvim-treesitter',
    lazy = false,    -- treesitter plugin does not support lazy-loading
    build = ':TSUpdate',  -- build is what should happen after installation
    --
    --  QUESTO STRONXZO NON FUNZIONA
    --
    config = function() -- the config function is a good place where to put code that should be run every launch
        vim.notify('loading treesitter...', vim.log.levels.INFO)
        myparsers = { "html","css","c","lua","python","vim","vimdoc","powershell","bash","markdown","markdown_inline","json","yaml"}
        require('nvim-treesitter').install(myparsers)
        -- see treesitter related code in config/ts.lua
    end,
}




