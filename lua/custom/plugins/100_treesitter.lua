-- this is from https://github.com/nvim-treesitter/nvim-treesitter

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
    -- },
    config = function()
        vim.notify('loading treesitter...', vim.log.levels.INFO)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "python", "vim", "vimdoc", "bash", "powershell", "markdown", "json", "yaml" },
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
 --   config = function()
    --    require('nvim-treesitter.install').compilers = { "gcc" }  -- if using gcc
    --    require('nvim-treesitter.configs').setup({  -- was 'nvim-treesitter' instead of 'nvim-treesitter.configs'
    --        -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    --        -- install_dir = vim.fn.stdpath('data') .. '/site',
    --        -- require('nvim-treesitter').install({ 'rust', 'javascript', 'zig' }):wait(300000) -- wait max. 5 minutes
    --        ensure_installed = { "python", "lua", "vim", "vimdoc", "bash", "powershell", "markdown", "json", "yaml",  },
    --        sync_install = false,  -- Install parsers synchronously (only applied to `ensure_installed`)
    --        auto_install = true,   -- Automatically install missing parsers when entering buffer
    --        -- ignore_install = {},   -- List of parsers to ignore installing (for "all")
    --        highlight = {
    --            enable = true,
    --            --  disable = function(lang, buf)
    --            --     local max_filesize = 100 * 1024 -- 100 KB
    --            --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --            --     if ok and stats and stats.size > max_filesize then
    --            --         return true
    --            --     end
    --            --  end,
    --            additional_vim_regex_highlighting = false,
    --        },
    --        indent = { enable = true, },
    --        -- incremental_selection = {
    --        -- enable = true,
    --        -- keymaps = {
    --        --        init_selection = '<C-space>', node_incremental = '<C-space>',
    --        --        scope_incremental = false, node_decremental = '<bs>',
    --        --    },
    --        -- },
    --    })
 --   end,
},


