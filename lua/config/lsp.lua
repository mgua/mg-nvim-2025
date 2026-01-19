-- lsp.lua
-- Server-specific LSP configurations
-- this neovim lsp.lua file contains configurations for mason/LSP
-- Main LSP setup has moved to lua/custom/plugins/200_mason.lua
--
-- This file is for:
--   - Server-specific settings (e.g., sqls database connections)
--   - Custom LSP handlers
--   - Diagnostic display options

vim.notify('lsp.lua additional setup...', vim.log.levels.INFO)

-- Suppress lspconfig deprecation warnings until mason-lspconfig updates
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("lspconfig") and msg:match("deprecated") then return end
  notify(msg, ...)
end



-- =============================================================================
-- DIAGNOSTIC DISPLAY OPTIONS
-- =============================================================================
vim.diagnostic.config({
    virtual_text = true,      -- Show inline diagnostics
    signs = true,             -- Show signs in gutter
    underline = true,         -- Underline problems
    update_in_insert = false, -- Don't update while typing
    severity_sort = true,     -- Sort by severity
})




-- BasedPyright (Python)
-- Uses pyproject.toml or pyrightconfig.json in project root for settings
-- lspconfig.basedpyright.setup({})

--- Optional: Server-specific configurations, with .sqls.yml in project root ---
--[[
# .sqls.yml template
# put such a file in your project root, with credentials. this will be used by sqls LSP server
#

connections:
  - alias: postgres_dev
    driver: postgresql
    data_source_name: postgresql://user:password@host:port/dbname?sslmode=disable
    # For your PostgreSQL connection

  - alias: mariadb_dev
    driver: mysql
    data_source_name: user:password@tcp(host:port)/dbname
    # For your MariaDB/MySQL connection

  - alias: mssql_dev
    driver: mssql
    data_source_name: sqlserver://user:password@host:port?database=dbname
    # For your MSSQL/SQL Server connection

--]]



print("LSP server-specific configuration loaded.")

