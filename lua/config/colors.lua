-- lua colors.lua

vim.cmd("colorscheme onedark") -- Color scheme in the case the colors file is not working
-- VS Code-like colors (applied after colorscheme loads)
--
-- the style variables defined here are matching capture rules (like treesitter's)
-- (to identify objects like @variable, @function ...)
-- to validate they are correctly setup, execute this at nvim prompt :hi @type.builtin
-- you should see @type.builtin  xxx guifg=#4ec9b0
--
-- Execute command ":Inspect" while cursor is on a keyword you should get the corresponding color
-- This shows the specific language (the file extension) on which the capture rule is applied.
-- Capture rule is how treesitter detects text objects.
-- Execute command ":lua vim.treesitter.start()" to be sure treesitter is running in current buffer
--
-- a small box filled with the defined color can be visualized, with a plugin like
-- brenoprata10/nvim-highlight-colors

vim.api.nvim_set_hl(0, '@type', { fg = '#4EC9B0' })
vim.api.nvim_set_hl(0, '@type.builtin', { fg = '#4EC9B0' })
vim.api.nvim_set_hl(0, '@constructor', { fg = '#4EC9B0' })
vim.api.nvim_set_hl(0, '@module', { fg = '#4EC9B0' })
vim.api.nvim_set_hl(0, '@function', { fg = '#DCDCAA' })
vim.api.nvim_set_hl(0, '@function.call', { fg = '#DCDCAA' })
vim.api.nvim_set_hl(0, '@function.builtin', { fg = '#DCDCAA' })
vim.api.nvim_set_hl(0, '@method', { fg = '#DCDCAA' })
vim.api.nvim_set_hl(0, '@method.call', { fg = '#DCDCAA' })
vim.api.nvim_set_hl(0, '@variable', { fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, '@variable.parameter', { fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, '@parameter', { fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, '@keyword', { fg = '#569CD6' })
vim.api.nvim_set_hl(0, '@keyword.function', { fg = '#569CD6' })
vim.api.nvim_set_hl(0, '@keyword.return', { fg = '#C586C0' })
vim.api.nvim_set_hl(0, '@keyword.import', { fg = '#C586C0' })
vim.api.nvim_set_hl(0, '@include', { fg = '#C586C0' })
vim.api.nvim_set_hl(0, '@string', { fg = '#CE9178' })
vim.api.nvim_set_hl(0, '@number', { fg = '#B5CEA8' })
vim.api.nvim_set_hl(0, '@comment', { fg = '#6A9955', italic = true })

-- LSP semantic tokens (from Pyright)
vim.api.nvim_set_hl(0, '@lsp.type.namespace', { fg = '#4EC9B0' })
vim.api.nvim_set_hl(0, '@lsp.type.function', { fg = '#DCDCAA' })
vim.api.nvim_set_hl(0, '@lsp.type.method', { fg = '#DCDCAA' })
vim.api.nvim_set_hl(0, '@lsp.type.class', { fg = '#4EC9B0' })
vim.api.nvim_set_hl(0, '@lsp.type.variable', { fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg = '#9CDCFE' })

-- HTML/Jinja template colors (VS Code style)
vim.api.nvim_set_hl(0, '@tag', { fg = '#569CD6' })           -- HTML tags
vim.api.nvim_set_hl(0, '@tag.builtin', { fg = '#569CD6' })
vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = '#808080' }) -- < > /
vim.api.nvim_set_hl(0, '@tag.attribute', { fg = '#9CDCFE' }) -- attributes like class=
vim.api.nvim_set_hl(0, '@attribute', { fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, '@punctuation.delimiter', { fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, '@punctuation.special', { fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, '@operator', { fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, '@constant', { fg = '#4FC1FF' })
vim.api.nvim_set_hl(0, '@markup.heading', { fg = '#569CD6', bold = true })
vim.api.nvim_set_hl(0, '@markup.link', { fg = '#CE9178' })


-- Matching parent delimiter highlight color
-- (this overrides colorscheme definition that may be not that visible)
vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#ff8800', fg = '#000000', bold = true })


-- nvtree colors
-- Opened folder
vim.api.nvim_set_hl(0, 'NvimTreeCursorLine', { fg = '#9CDCFE', bg = '#3a3a5a', bold = true, })  -- current line
vim.api.nvim_set_hl(0, 'NvimTreeOpenedFile', { fg = '#00ff88', bold = true })                     -- Opened file highlight
vim.api.nvim_set_hl(0, 'NvimTreeFolderName', { fg = '#7aa2f7' })                                  -- Folder name
vim.api.nvim_set_hl(0, 'NvimTreeOpenedFolderName', { fg = '#7aa2f7' })                            -- Opened folder


return {} -- Return empty table for module exports

