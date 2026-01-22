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
-- To check LSP status:       :checkhealth lsp
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
    -- "basedpyright",         -- Python LSP (stricter pyright fork)
    -- Commented out: Mason has build issues on Windows
    -- Install globally with: npm install -g basedpyright
    -- Config remains in server_configs, setup done manually below

    -- Shell scripting
    "bashls",               -- Bash LSP
    "powershell_es",        -- PowerShell Editor Services

    "lua_ls",               -- Lua LSP (for Neovim config editing)

    "intelephense",         -- PHP LSP (requires node.js)

    "sqls",                 -- SQL LSP (configure via .sqls.yml in project root)

    -- Web (uncomment if needed)
    "html",                 -- HTML LSP
    "cssls",                -- CSS LSP
    -- "jsonls",            -- JSON LSP
    -- "yamlls",            -- YAML LSP
}

-- =============================================================================
-- EXTERNAL SERVERS (installed outside Mason)
-- =============================================================================
-- These servers are installed via npm, cargo, pip, etc. instead of Mason
-- Mason will show a warning if user tries to install them via :MasonInstall
--
local external_servers = {
    "basedpyright",         -- npm install -g basedpyright
}

-- Installation commands for external servers (used in warning messages)
local external_install_commands = {
    basedpyright = "npm install -g basedpyright",
    -- Add more as needed:
    -- rust_analyzer = "rustup component add rust-analyzer",
}


-- =============================================================================
-- LSP KEYMAPS (single source of truth)
-- =============================================================================
-- These keymaps are attached when an LSP client connects to a buffer.
-- See which-key.lua for documentation display.
--
-- QUICK REFERENCE:
--   Navigation:     gd (definition), gD (declaration), gi (implementation),
--                   gr (references), gT (type definition)
--   Documentation:  K (hover)
--   Refactoring:    <leader>rn (rename), <leader>ca (code action)
--   Diagnostics:    [d / ]d (prev/next), <leader>ld (line diagnostics)
--   Formatting:     <leader>lf (format)
--   Signature:      <C-s> in insert mode (signature help)
--
local function setup_lsp_keymaps()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            local opts = { noremap = true, silent = true, buffer = ev.buf }

            -- ===== Navigation =====
            opts.desc = "Go to Declaration"
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

            opts.desc = "Go to Definition"
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

            opts.desc = "Go to Implementation"
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

            opts.desc = "Find References"
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

            opts.desc = "Go to Type Definition"
            vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, opts)

            -- ===== Documentation =====
            opts.desc = "Hover Documentation"
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

            opts.desc = "Signature Help"
            vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, opts)

            -- ===== Refactoring =====
            opts.desc = "Rename Symbol"
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

            opts.desc = "Code Action"
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, opts)

            -- ===== Diagnostics =====
            opts.desc = "Previous Diagnostic"
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)

            opts.desc = "Next Diagnostic"
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

            opts.desc = "Line Diagnostics (float)"
            vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, opts)

            opts.desc = "Send Diagnostics to Quickfix"
            vim.keymap.set('n', '<leader>lq', vim.diagnostic.setqflist, opts)

            -- ===== Formatting =====
            opts.desc = "Format Code"
            vim.keymap.set('n', '<leader>lf', function()
                vim.lsp.buf.format { async = true }
            end, opts)

            opts.desc = "Format Selection"
            vim.keymap.set('v', '<leader>lf', function()
                vim.lsp.buf.format { async = true }
            end, opts)

            -- ===== Workspace =====
            opts.desc = "Add Workspace Folder"
            vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, opts)

            opts.desc = "Remove Workspace Folder"
            vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, opts)

            opts.desc = "List Workspace Folders"
            vim.keymap.set('n', '<leader>lwl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
        end,
    })
end


-- =============================================================================
-- SERVER-SPECIFIC CONFIGURATIONS
-- Neovim 0.11+: uses vim.lsp.config() instead of require('lspconfig')
-- =============================================================================
local server_configs = {

    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    },

    basedpyright = {
        settings = {
            basedpyright = {
                typeCheckingMode = "standard",
                analysis = {
                    autoImportCompletions = true,
                    diagnosticMode = "openFilesOnly",
                    useLibraryCodeForTypes = true,
                    inlayHints = {
                        callArgumentNames = "partial",
                        functionReturnTypes = true,
                        pytestParameters = true,
                        variableTypes = true,
                    },
                },
            },
            python = {
                pythonVersion = "3.12",
                -- venv integration handled by venv-selector plugin
                -- see config/venv_selector.lua
            },
        },
    },

    intelephense = {
        settings = {
            intelephense = {
                environment = {
                    phpVersion = "8.2",
                },
                stubs = {
                    "apache", "bcmath", "bz2", "Core", "curl", "date",
                    "dom", "fileinfo", "filter", "gd", "hash", "iconv",
                    "intl", "json", "libxml", "mbstring", "mysqli",
                    "openssl", "pcntl", "pcre", "PDO", "pdo_mysql",
                    "Phar", "posix", "readline", "Reflection", "regex",
                    "session", "SimpleXML", "sodium", "SPL", "standard",
                    "superglobals", "tokenizer", "xml", "xmlreader",
                    "xmlwriter", "zip", "zlib",
                },
                files = {
                    maxSize = 5000000,
                },
                format = {
                    enable = true,
                },
            },
        },
    },
}


-- =============================================================================
-- PLUGIN SPECIFICATION
-- =============================================================================

return {

    { -- mason: package manager for LSP servers, formatters, linters
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
        dependencies = {
            'mason-org/mason.nvim',
        },
        config = function()
            vim.notify('configuring mason-lspconfig (nvim 0.11+)...', vim.log.levels.INFO)

            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = lsp_servers,
                automatic_enable = false,
            })

            -- Configure all servers (Mason-managed + external)
            for server_name, config in pairs(server_configs) do
                vim.lsp.config(server_name, config)
            end

            -- Enable Mason-managed servers
            for _, server_name in ipairs(lsp_servers) do
                vim.lsp.enable(server_name)
            end

            -- Enable external servers (npm, cargo, etc.)
            for _, server_name in ipairs(external_servers) do
                vim.lsp.enable(server_name)
            end

            setup_lsp_keymaps()

            -- Warn if user tries to install external servers via Mason
            vim.api.nvim_create_autocmd('User', {
                pattern = 'MasonInstallPre',
                callback = function(ev)
                    local pkg = ev.data and ev.data.pkg_name
                    if vim.tbl_contains(external_servers, pkg) then
                        local install_cmd = external_install_commands[pkg] or ('install ' .. pkg .. ' manually')
                        vim.notify(
                            '⚠️  ' .. pkg .. ' is managed externally, not via Mason.\n\n' ..
                            'Install with:\n  ' .. install_cmd .. '\n\n' ..
                            'See external_servers table in 200_mason.lua',
                            vim.log.levels.WARN
                        )
                    end
                end,
            })

            local all_servers = vim.list_extend(
                vim.list_extend({}, lsp_servers),
                external_servers
            )
            vim.notify('LSP servers: ' .. table.concat(all_servers, ', '), vim.log.levels.DEBUG)
        end,
    },

}
