-- 200_mason.lua
-- Mason plugin loader and ALL LSP server configuration
-- https://github.com/mgua/mg-nvim-2025
--
-- Linux: ~/.config/nvim/lua/custom/plugins/200_mason.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\custom\plugins\200_mason.lua
--
-- Mason manages LSP servers, formatters, linters, and DAP adapters
-- https://github.com/mason-org/mason.nvim
--
-- To see installed servers:  :Mason
-- To install manually:       :MasonInstall <server>
-- To check LSP status:       :LspInfo
-- To check attached LSP:     :lua print(vim.inspect(vim.lsp.get_clients()))
--
-- =============================================================================
-- LSP SERVER DEFINITIONS (SINGLE SOURCE OF TRUTH)
-- =============================================================================
-- Edit this list to add/remove language server support
-- Server names must match Mason registry: https://mason-registry.dev/registry/list
--
-- for other post setup configs see lua/config/lsp.lua (invoked by init.lua)
--

local lsp_servers = {
    -- Python
    "basedpyright",         -- Python LSP (stricter pyright fork)

    -- Shell scripting
    "bashls",               -- Bash LSP
    "powershell_es",        -- PowerShell Editor Services

    "lua_ls",               -- Lua LSP (for Neovim config editing)

    "intelephense",         -- PHP LSP (required node.js)

    "sqls",                 -- SQL LSP (configure via .sqls.yml in project root)

    -- Web (uncomment if needed)
    "html",              -- HTML LSP
    "cssls",             -- CSS LSP
    -- "jsonls",            -- JSON LSP
    -- "yamlls",            -- YAML LSP
}


local function setup_lsp_keymaps()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            local opts = { noremap = true, silent = true, buffer = ev.buf }

            -- Navigation
            opts.desc = "Go to Declaration"
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

            opts.desc = "Go to Definition"
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

            opts.desc = "Go to Implementation"
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

            opts.desc = "Find References"
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

            -- Documentation
            opts.desc = "Hover Documentation"
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

            -- Refactoring
            opts.desc = "Rename Symbol"
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

            opts.desc = "Code Action"
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

            -- Diagnostics
            opts.desc = "Previous Diagnostic"
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)

            opts.desc = "Next Diagnostic"
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

            -- Formatting
            opts.desc = "Format Code"
            vim.keymap.set('n', '<leader>lf', function()
                vim.lsp.buf.format { async = true }
            end, opts)
        end,
    })
end


-- =============================================================================
-- SERVER-SPECIFIC CONFIGURATIONS (used by mason-lspconfig handlers)
-- =============================================================================
local server_configs = {

    lua_ls = {      -- FUNDAMENTAL this key (lua_ls) has to match the lsp_servers entry
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },   -- Lua LSP: recognize vim global, neovim runtime
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    },


    -- Python LSP
    basedpyright = {
        settings = {
            basedpyright = {
                -- Use standard type checking (options: off, basic, standard, strict, all)
                typeCheckingMode = "standard",

                -- Analysis settings
                analysis = {
                    -- Auto-detect imports from installed packages
                    autoImportCompletions = true,

                    -- Diagnostic mode: workspace analyzes all files, openFilesOnly just open ones
                    diagnosticMode = "openFilesOnly",

                    -- Use library stubs for type info
                    useLibraryCodeForTypes = true,

                    -- Inlay hints (function params, variable types)
                    inlayHints = {
                        callArgumentNames = "partial",  -- off, partial, all
                        functionReturnTypes = true,
                        pytestParameters = true,
                        variableTypes = true,
                    },
                },
            },
            python = {
                -- Python version for analysis (adjust to your target)
                pythonVersion = "3.12",
                -- *********************************************************
                -- mgua: 19jan2026: here we need to integrate with our automatic venv detector
                -- see config/venv_selector.lua
                -- Virtual environment (auto-detected, but can specify)
                -- venvPath = ".",
                -- venv = ".venv", or "venv_<projectname>"
                -- *********************************************************
            },
        },
    },



    -- PHP LSP
    -- To validate: :e some_file.php
    -- :LspInfo
    intelephense = {
        settings = {
            intelephense = {
                -- PHP version for compatibility checks
                environment = {
                    phpVersion = "8.2",
                },
                -- Additional stubs for framework/extension support
                stubs = {
                    "apache", "bcmath", "bz2", "Core", "curl", "date",
                    "dom", "fileinfo", "filter", "gd", "hash", "iconv",
                    "intl", "json", "libxml", "mbstring", "mysqli",
                    "openssl", "pcntl", "pcre", "PDO", "pdo_mysql",
                    "Phar", "posix", "readline", "Reflection", "regex",
                    "session", "SimpleXML", "sodium", "SPL", "standard",
                    "superglobals", "tokenizer", "xml", "xmlreader",
                    "xmlwriter", "zip", "zlib",
                    -- Uncomment if needed:
                    -- "wordpress", "redis", "memcached", "mongodb",
                },
                -- File handling
                files = {
                    maxSize = 5000000,  -- 5MB, increase for large files
                },
                -- Formatting (or use external like php-cs-fixer)
                format = {
                    enable = true,
                },
            },
        },
    },


    -- Add other server-specific configs here
    -- basedpyright = { settings = {...} },
}




-- =============================================================================
-- PLUGIN SPECIFICATION
-- =============================================================================

return {

    {   -- nvim-lspconfig: core LSP client configuration
        -- core component to allow nvim to use LSP servers
        -- mason can not work without this
        'neovim/nvim-lspconfig',
    },

    { -- mason: package manager for LSP servers, formatters, linters
      -- https://github.com/mason-org/mason.nvim
      -- requires git, curl/wget, unzip, gzip, tar
        'mason-org/mason.nvim',
        build = ':MasonUpdate',
        opts = {
            ui = {
                icons = {
                    package_installed   = "✓",
                    package_pending     = "➜",
                    package_uninstalled = "✗"
                }
            }
        },
    },

    { -- mason-lspconfig: bridge between mason and lspconfig
        'mason-org/mason-lspconfig.nvim',
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            'neovim/nvim-lspconfig',
        },
        config = function()
            vim.notify('configuring mason-lspconfig...', vim.log.levels.INFO)

            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = lsp_servers,
                automatic_enable = false,  -- we do not perform auto-setup: we use handlers
                handlers = {
                    -- Default handler: called for each installed server
                    function(server_name)
                        local config = server_configs[server_name] or {}
                        require('lspconfig')[server_name].setup(config)
                    end,
                },
            })

            setup_lsp_keymaps()           -- Setup keymaps

            vim.notify('LSP servers: ' .. table.concat(lsp_servers, ', '), vim.log.levels.DEBUG)
        end,
    },

}




