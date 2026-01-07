-- ts.lua
-- Linux: ~/.config/nvim/lua/config/languages.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\languages.lua
--
-- this file contains configurations for treesitter
-- this is invoked by init.lua, after the plugins have been loaded
--
-- add additional treesitter configs if needed
--
-- require syntax
-- require('nvim-treesitter.install').install('lua')
--         \_____________________/    \______/
--          returns table           calls install function
--          with install field      from that table
--
-- this is the place where to put settings that are independent from setup or plugin loading
--
vim.notify('ts.lua additional setup...', vim.log.levels.INFO)

myparsers = { "html","css","c","lua","python","vim","vimdoc","powershell","bash","markdown","markdown_inline","json","yaml","awk","perl"}
vim.api.nvim_create_autocmd('FileType', {
    pattern = myparsers,
    callback = function()
        vim.treesitter.start()                                              -- syntax highlighting, provided by Neovim
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'                 -- folds, provided by Neovim
        -- vim.wo.foldmethod = 'expr'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"   -- indentation, provided by nvim-treesitter (in visual mode?)
    end,
})


