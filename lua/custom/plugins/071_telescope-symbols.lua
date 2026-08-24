-- 071_telescope-symbols.lua
-- Unicode/emoji/math/latex symbol sources for telescope's built-in `symbols` picker
-- https://github.com/nvim-telescope/telescope-symbols.nvim
--
-- Place in: lua/custom/plugins/071_telescope-symbols.lua
--
-- Keymap: <leader>fe opens a :digraphs-like picker; <CR> inserts at the cursor.
-- These are REAL unicode, so they render in any markdown viewer - unlike
-- Nerd Font glyphs (Private Use Area, need the font).
--
--   to explore:
--   :Telescope symbols

return {
    'nvim-telescope/telescope-symbols.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },

    config = function()
        vim.keymap.set('n', '<leader>fe', function()
            require('telescope.builtin').symbols({ sources = { 'emoji', 'gitmoji', 'math', 'latex' } })
        end, { desc = 'Insert emoji / symbol' })
    end,
}
