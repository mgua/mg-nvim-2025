--  'numToStr/Comment.nvim'
-- multiple lines and block comments
-- https://github.com/numToStr/Comment.nvim 
-- https://www.youtube.com/watch?v=-InmtHhk2qM
--
-- simple use: 
--	<leader>gc3j or <leader>gc3<DOWN> line comments 3 lines down
--	<leader>gb13j or <leader>gb13<DOWN> block comments 13 lines down
--



return { 
  -- may have issues without the following option vim.opt.timeoutlen = 1000
  -- :h comment.config
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup({
        -- LHS of operator-pending mapping in NORMAL + VISUAL mode
        opleader = {
          line = "gc",   -- line-comment keymap
          block = "gb",  -- block-comment keymap
        },
      -- operator-pending mapping
      -- Includes:
      --   'gcc'   -> line-comment the current line       <leader>gcc
      --   'gcb'   -> block-comment the current line      select block then <leader>gcb
      --   'gc[count]{motion}' -> line-comment the region contained in {motion}   <leader>gc3j or <leader>gc3<DOWN> comments 3 lines down
      --   'gb[count]{motion}' -> block-comment the region contained in {motion}
        basic = true,
    })
  end
}
