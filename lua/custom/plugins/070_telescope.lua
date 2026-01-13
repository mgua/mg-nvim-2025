-- 070_telescope.lua
-- Fuzzy finder for files, text, LSP symbols, git, and more
-- https://github.com/nvim-telescope/telescope.nvim
--
-- Place in: lua/custom/plugins/070_telescope.lua
--
-- Keymaps: <leader>f* for find operations
--          <leader>g* for git operations
--
-- Note: <leader>b uses fzf-lua (see first-keymaps.lua)
--
-- Dependencies:
--   - ripgrep (rg) for live_grep: https://github.com/BurntSushi/ripgrep
--   - fd for faster file finding (optional): https://github.com/sharkdp/fd
--
--   to explore:
--   :Telescope find-files

return {
    'nvim-telescope/telescope.nvim',
    -- branch = '0.1.x',    -- this has errors on nvim 0.11
    branch = 'master',      -- this allows more recent update 0.2.1 as jan 2026
    dependencies = {
        'nvim-lua/plenary.nvim',
    },

    config = function()
        vim.notify('  loading telescope...', vim.log.levels.INFO)

        local telescope = require('telescope')
        local actions = require('telescope.actions')
        local builtin = require('telescope.builtin')

        telescope.setup({
            defaults = {
                layout_strategy = 'horizontal',
                layout_config = {
                    horizontal = {
                        prompt_position = 'top',
                        preview_width = 0.55,
                    },
                    width = 0.87,
                    height = 0.80,
                },
                sorting_strategy = 'ascending',
                prompt_prefix = '   ',
                selection_caret = '> ',     -- added to identify the currently selected option mgua 11.01.2026
                path_display = { 'truncate' },
                file_ignore_patterns = {
                    'node_modules',
                    '.git/',
                    '__pycache__',
                },
                mappings = {
                    i = {
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                        ['<C-c>'] = actions.close,
                        ['<Esc>'] = actions.close,
                        ['<CR>'] = actions.select_default,
                        ['<C-x>'] = actions.select_horizontal,
                        ['<C-v>'] = actions.select_vertical,
                        ['<C-t>'] = actions.select_tab,
                        ['<C-h>'] = 'which_key',
                    },
                    n = {
                        ['q'] = actions.close,
                        ['<Esc>'] = actions.close,
                    },
                },
            },
            pickers = {
                find_files = {
                    hidden = false,
                    follow = true,
                },
                buffers = {
                    sort_lastused = true,
                    mappings = {
                        i = { ['<C-d>'] = actions.delete_buffer },
                        n = { ['dd'] = actions.delete_buffer },
                    },
                },
                colorscheme = {   -- theme preview <leader>ft
                    enable_preview = true,
                },
            },
        })

        -- ====================================================================
        -- KEYMAPS - with safety checks
        -- ====================================================================
        local map = vim.keymap.set

        -- Helper: only map if the builtin function exists
        local function safe_map(mode, lhs, rhs, opts)
            if rhs ~= nil then
                map(mode, lhs, rhs, opts)
            else
                vim.notify('Telescope: skipping ' .. lhs .. ' (function not available)', vim.log.levels.WARN)
            end
        end

        -- Files
        safe_map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
        safe_map('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })

        -- Grep/Search
        safe_map('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
        safe_map('n', '<leader>fw', builtin.grep_string, { desc = 'Grep word under cursor' })
        safe_map('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { desc = 'Fuzzy find in buffer' })

        safe_map('n', '<leader>fG',  -- Grep from current buffer's directory tree
            function()
              local dir = vim.fn.expand('%:p:h')  -- current buffer's parent directory
              require('telescope.builtin').live_grep({ search_dirs = { dir } })
            end, { desc = 'Grep from buffer dir' }
        )

        -- LSP
        safe_map('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document symbols' })
        safe_map('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Workspace symbols' })
        safe_map('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics' })
        safe_map('n', '<leader>fi', builtin.lsp_implementations, { desc = 'Implementations' })
        safe_map('n', '<leader>fR', builtin.lsp_references, { desc = 'References' })

        -- Vim internals
        safe_map('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
        safe_map('n', '<leader>fk', builtin.keymaps, { desc = 'Keymaps' })
        safe_map('n', '<leader>ft', builtin.colorscheme, { desc = 'Find Colorscheme' })
        safe_map('n', '<leader>fc', builtin.commands, { desc = 'Commands' })
        safe_map('n', '<leader>fC', builtin.command_history, { desc = 'Command history' })
        safe_map('n', '<leader>fm', builtin.marks, { desc = 'Marks' })
        safe_map('n', '<leader>fj', builtin.jumplist, { desc = 'Jump list' })
        safe_map('n', '<leader>fq', builtin.quickfix, { desc = 'Quickfix list' })
        safe_map('n', '<leader>fl', builtin.loclist, { desc = 'Location list' })
        safe_map('n', '<leader>f"', builtin.registers, { desc = 'Registers' })

        -- Meta
        safe_map('n', '<leader>f.', builtin.builtin, { desc = 'All Telescope pickers' })
        safe_map('n', '<leader>fb', builtin.buffers, { desc = 'Buffers (Telescope)' })
        safe_map('n', '<leader><leader>', builtin.resume, { desc = 'Resume last picker' })

        -- Git
        safe_map('n', '<leader>gf', builtin.git_files, { desc = 'Git files' })
        safe_map('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
        safe_map('n', '<leader>gC', builtin.git_bcommits, { desc = 'Git commits (buffer)' })
        safe_map('n', '<leader>gb', builtin.git_branches, { desc = 'Git branches' })
        safe_map('n', '<leader>gS', builtin.git_status, { desc = 'Git status' })
        safe_map('n', '<leader>gt', builtin.git_stash, { desc = 'Git stash' })

    end,
}


