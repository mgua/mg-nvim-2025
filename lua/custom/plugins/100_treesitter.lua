-- this is from https://github.com/nvim-treesitter/nvim-treesitter
-- treesitter plugin loader, for lazy plugin manager
--
-- how do you know if Treesitter is active in your current buffer?
--    try to see via command mode if TS<tab> shows an adequate number of options (5 options is not ok)
--    try to use  :Inspect while cursor is on some keyword
--    try         :TSInstall yourlanguage
--    you can launch treesitter in the current buffer with
--                :lua vim.treesitter.start()

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
    -- see other treesitter related code in config/ts.lua


return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',

    opts = {
        highlight = {
            enable = true, -- Enable syntax highlighting
        },
        indent = {
            enable = true,  -- Enable treesitter-based indentation
        },

        install = {
            ensure_installed = {  -- 1. List the parsers you want installed/updated
                "html", "css", "c", "lua", "python", "vim",
                "vimdoc", "powershell", "bash", "markdown",
                "markdown_inline", "json", "yaml"
            },

            compilers = {         -- 2. Explicitly define the compiler preference order
                "gcc",  -- Tries your MSYS2 GCC first
                -- "clang",
                "cl",   -- We intentionally leave "cl" (MSVC) as last choice
            },
        },
    },

    config = function(_, opts)
        vim.notify('loading treesitter...', vim.log.levels.INFO)

        -- Call the setup function with the options defined above
        -- Old nvim-treesitter branch was relying on a configs.lua setup file
        -- which is not needed anymore now
        -- there is a config.lua in the folder  (not configs.lua)
        --    C:\Users\mgua\AppData\Local\nvim-data\lazy\nvim-treesitter\lua\nvim-treesitter
        -- documentation says that you should invoke
        --    require'nvim-treesitter'.setup()

        require('nvim-treesitter').setup(opts)
    end,
}




