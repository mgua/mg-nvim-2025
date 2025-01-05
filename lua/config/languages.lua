-- languages.lua
-- Linux: ~/.config/nvim/lua/config/languages.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\languages.lua

local lspconfig = require('lspconfig')  -- This require is fine as it's a plugin

-- Python configuration
lspconfig.pyright.setup{
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            }
        }
    }
}

-- LSP servers installation via Mason
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'pyright',        -- Python
        'lua_ls',         -- Lua
        'jsonls',         -- JSON
        'yamlls',         -- YAML
    }
})

return {} -- Return empty table for module exports