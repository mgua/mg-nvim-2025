-- 100_treesitter.lua
-- Treesitter plugin loader and ALL treesitter-related configuration
-- https://github.com/mgua/mg-nvim-2025
--
-- Linux: ~/.config/nvim/lua/custom/plugins/100_treesitter.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\custom\plugins\100_treesitter.lua
--
-- how do you know if Treesitter is active in your current buffer?
--    try to see via command mode if TS<tab> shows an adequate number of options (5 options is not ok)
--    try to use  :Inspect while cursor is on some keyword
--    try         :TSInstall yourlanguage
--    you can launch treesitter in the current buffer with
--                :lua vim.treesitter.start()
--
--    when opening a .lua file
--    :lua print(vim.wo.foldmethod) -- should output expr (treesitter) and not indent (fallback)
--
--    when opening a file for which we do not have a loaded treesitter parser
--    :lua print(vim.wo.foldmethod) -- should output indent (fallback)
--
--
-- treesitter https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file
--
-- windows prerequirements:
--    -  winget install Microsoft.VisualStudio.2022.BuildTools
--  OR
--    -  winget install zig.zig
--  OR
--    -  winget install gcc
-- - winget install  OpenJS.NodeJS.LTS
-- - npm install -g tree-sitter-cli
--
-- linux prerequirements: apt install build-essentials git tar curl node.js
--
-- see :help nvim-treesitter.txt
-- CAUTION: on github, the treesitter repo has the "old" master branch which is not (jan 2026) legacy. new
-- code is in the main branch, but it is a full rewrite, and documentation is not updated. TJ Devries video
-- is specific for the now legacy version
-- here we try to make the new version working, but configurations apparently have to be adapted
--
--
-- some aspects here may be relevant (post by YourBroFred)
--  https://www.reddit.com/r/neovim/comments/1l3z4j4/help_with_new_treesitter_setup_in_neovim_default/?chainedPosts=t3_1bj5a4j
-- see checkhealth nvim-treesitter
--
--  in the following post folke says zig can not be used anymore
--  https://www.reddit.com/r/neovim/comments/1pen2ot/comment/nsdxna4/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
--
-- it can be that TSInstall python fails with some error like
-- "Could not rename temp: EPERM: operation not permitted"
-- in this case it is possible there are unwante residues in the temp folder
--   Remove-Item -Recurse -Force "$env:TEMP\nvim\tree-sitter-python*" -ErrorAction SilentlyContinue
--   Remove-Item -Recurse -Force "$env:TEMP\nvim\tree-sitter-python-tmp" -ErrorAction SilentlyContinue

--
-- =============================================================================
-- PARSER DEFINITIONS (SINGLE SOURCE OF TRUTH)
-- =============================================================================
-- Edit these lists to add/remove language support

-- Bundled in nvim 0.11 core (parser included, no installation needed)
local nvim_core_parsers = {
    "c", "lua", "vim", "vimdoc", "query"
}

-- Require nvim-treesitter plugin (will be installed via ensure_installed)
-- add here the parsers you want to manage. filetypes not listed here will have
-- syntax, folding and indent processed via default rules, as specified in init.lua
local plugin_parsers = {
    "html", "css", "python", "powershell", "bash", "json", "yaml", "awk", "perl",
    "markdown", "markdown_inline"
}

-- Combined list (both get same treesitter treatment)
local all_ts_filetypes = vim.list_extend(vim.list_extend({}, nvim_core_parsers), plugin_parsers)

-- =============================================================================
-- TREESITTER SETTINGS APPLIED TO ALL SUPPORTED FILETYPES
-- These override the basic settings in init.lua
-- =============================================================================
local function apply_treesitter_settings()
    -- SYNTAX: Treesitter-based highlighting (more accurate than regex)
    -- Note: For bundled parsers this is automatic, but calling it is harmless
    vim.treesitter.start()

    -- FOLDING: Treesitter-based (understands code structure)
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldlevel = 99  -- Start with all folds open

    -- INDENTATION: Treesitter-based (context-aware)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end



-- treesitter plugin loader, for lazy plugin manager

return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',    -- new version, completely refactored, in main branch
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
            ensure_installed = plugin_parsers,

            -- {  -- 1. List the parsers you want installed/updated
            --    -- commented c, lua, vim, vimdoc, query jan 19 2026
            --    -- (gemini suggestion because these are preinstalled in core nvim 0.11)
            --    -- run :TSUninstall c lua vim vimdoc query to revert to preinstalled versions
            --    "html", "css", "python", "powershell", "bash",
            --    "markdown", "markdown_inline", "json", "yaml"
            -- },

            compilers = {         -- 2. Explicitly define the compiler preference order
                -- this setting is probably not used by current treesitter
                -- because the error message always complains about cl being unavailable, whatever we write here
                -- see also https://docs.rs/cc/latest/cc/#compile-time-requirements
                "zig",  -- Tries the new zig first (winget install zig.zig)
                "gcc",  -- Then MSYS2 GCC (where.exe gcc)
                "C:/ProgramData/mingw64/mingw64/bin/gcc.exe",  -- gcc with full path
                -- "clang",
                -- "cl",   -- We intentionally leave "cl" (MSVC) as last choice
            },
        },
    },

    config = function(_, opts)
        vim.notify('loading treesitter...', vim.log.levels.INFO)
        require('nvim-treesitter').setup(opts)
        -- Apply treesitter settings to all supported filetypes
        vim.api.nvim_create_autocmd('FileType', {
            pattern = all_ts_filetypes,
            callback = apply_treesitter_settings,
            desc = 'Apply treesitter syntax/fold/indent settings',
        })

        vim.notify('treesitter filetypes: ' .. table.concat(all_ts_filetypes, ', '), vim.log.levels.DEBUG)
    end,
}




