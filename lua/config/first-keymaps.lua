-- first-keymaps.lua
-- Linux: ~/.config/nvim/lua/config/first-keymaps.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\first-keymaps.lua
--
-- this is invoked by init.lua, after the plugins have been loaded
--
-- to debug the keymap "g?" execute ":nmap g?" or ":verbose nmap g?"
--
-- leader key is defined in init.lua

local map = vim.keymap.set
vim.notify('  first-keymaps...', vim.log.levels.INFO)

-- ============================================================================
-- Buffer Navigation - using [ and ] prefix (vim convention for prev/next)
-- ============================================================================
-- NOTE: if ]b or [b don't work, check with :verbose nmap ]b
-- Common culprits: plugins overriding, or timeout issues

map('n', '[b', '<cmd>bprev<CR>', { desc = 'Previous buffer', noremap = true, silent = true })
map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer', noremap = true, silent = true })

-- Italian keyboard alternatives (è = [, + = ])
map('n', 'èb', '<cmd>bprev<CR>', { desc = 'Previous buffer' })
map('n', '+b', '<cmd>bnext<CR>', { desc = 'Next buffer' })

-- ============================================================================
-- Buffer Selection with <leader>b - opens fzf-lua buffer picker
-- ============================================================================
-- This provides a visual buffer selector instead of just cycling
map('n', '<leader>b', function()
    -- Try fzf-lua first (preferred, already in your config)
    local ok, fzf = pcall(require, 'fzf-lua')
    if ok then
        fzf.buffers({
            sort_lastused = true,    -- Most recently used first
            show_unloaded = false,   -- Hide unloaded buffers
        })
    else
        -- Fallback: use built-in buffer list with wildmenu completion
        vim.cmd('set wildcharm=<C-z>')
        vim.api.nvim_feedkeys(':buffer <C-z>', 'n', false)
    end
end, { desc = 'Buffer picker (fzf)' })

-- Alternative: <leader>B for buffer list (simple listing)
map('n', '<leader>B', '<cmd>ls<CR>:buffer<Space>', { desc = 'Buffer list + select' })

-- ============================================================================
-- Tab Navigation - using [ and ] prefix
-- ============================================================================
map('n', '[t', 'gT', { desc = 'Previous tab', noremap = true })
map('n', ']t', 'gt', { desc = 'Next tab', noremap = true })

-- Italian keyboard alternatives
map('n', 'èt', 'gT', { desc = 'Previous tab' })
map('n', '+t', 'gt', { desc = 'Next tab' })

-- ============================================================================
-- Quickfix/Location list navigation
-- ============================================================================
map('n', '[q', '<cmd>cprev<CR>', { desc = 'Previous quickfix' })
map('n', ']q', '<cmd>cnext<CR>', { desc = 'Next quickfix' })
map('n', '[l', '<cmd>lprev<CR>', { desc = 'Previous loclist' })
map('n', ']l', '<cmd>lnext<CR>', { desc = 'Next loclist' })

-- ============================================================================
-- Window Movement (using Ctrl + hjkl)
-- ============================================================================
-- we avoid using CTRL being this often trapped by term emulators or multiplexers (tmux)
-- but these are so common they're worth having
map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

map('i', '<C-w>', '<Nop>')          -- disable ctrl-w in insert mode
map('n', '<leader>w', '<C-w>w', { desc = 'Cycle windows' })

-- ============================================================================
-- Yank Highlight (visual feedback when yanking)
-- ============================================================================
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    callback = function()
        vim.highlight.on_yank({
            timeout = 250,
            on_visual = true
        })
    end
})

-- ============================================================================
-- Digraph reminder (for special characters)
-- ============================================================================
-- <CTRL-K>z'   ->  ź
-- <CTRL-K>u:   ->  ü
-- <CTRL-K>a>   ->  â

return {}
