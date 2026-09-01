--  'numToStr/Comment.nvim'
-- multiple lines and block comments
-- https://github.com/numToStr/Comment.nvim 
-- https://www.youtube.com/watch?v=-InmtHhk2qM
--
-- simple use (NOTE: gc/gb are plain mappings, the leader key is NOT involved):
--	gc3j or gc3<DOWN>	line comments 3 lines down
--	gb13j or gb13<DOWN>	block comments 13 lines down
--
-- leader shortcuts added below (see config function):
--	VISUAL: <leader>/ or <leader>gc  toggle line comment on the selection
--	VISUAL: <leader>gb               toggle block comment on the selection
--	NORMAL: <leader>/                toggle comment on the current line
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
      --   'gcc'   -> line-comment the current line
      --   'gcb'   -> block-comment the current line      (select block then gcb)
      --   'gc[count]{motion}' -> line-comment the region contained in {motion}   gc3j or gc3<DOWN> comments 3 lines down
      --   'gb[count]{motion}' -> block-comment the region contained in {motion}
        basic = true,
    })

    -- ------------------------------------------------------------------
    -- Fix: "[Comment.nvim] nil" on filetypes with no treesitter parser
    -- ------------------------------------------------------------------
    -- Comment/ft.lua:calculate() guards treesitter with
    --     local ok, parser = pcall(vim.treesitter.get_parser, buf)
    --     if not ok then return ft.get(...) end
    -- That assumes get_parser THROWS when no parser is available. On Neovim
    -- 0.12 it returns nil instead, so ok == true and parser == nil, and the
    -- next line indexes nil ("attempt to index local 'tree'"). The error is
    -- then swallowed by Comment/utils.lua:catch(), which prints err.msg --
    -- nil for a plain runtime error -- hence the bare "[Comment.nvim] nil"
    -- and no comment being toggled.
    --
    -- Only filetypes whose parser is missing are affected. Lua works because
    -- its parser ships with Neovim; sh/bash has no parser here, so shell
    -- scripts failed. Restoring the missing nil check is enough: returning
    -- ft.get() keeps the plugin's own fallback path, so a filetype with no
    -- entry still falls through to Neovim's 'commentstring', and blockwise on
    -- a filetype without block comments still raises the plugin's real
    -- "doesn't support block comments!" message instead of "nil".
    --
    -- Patched here rather than in the plugin so a Lazy update cannot revert it.
    local ft = require('Comment.ft')
    local calculate_orig = ft.calculate
    ft.calculate = function(ctx)
      local ok, parser = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
      if not ok or not parser then
        return ft.get(vim.bo.filetype, ctx.ctype)
      end
      return calculate_orig(ctx)
    end

    -- ------------------------------------------------------------------
    -- Leader-based comment toggles
    -- ------------------------------------------------------------------
    -- These call Comment.nvim's Lua API directly instead of remapping to the
    -- "gc"/"gb" keys. Feeding those keys back through the mapping stack is
    -- unreliable here: which-key installs a buffer-local "g" trigger with
    -- nowait, which can swallow the "g" before Comment.nvim's operator sees
    -- it. Calling the API avoids the keyboard entirely.
    -- Pattern is the one documented in Comment.nvim's api.lua (:h comment.api).
    local api = require('Comment.api')
    local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)

    -- Motion string that Comment.api expects for the current selection.
    -- Shift+Arrow / mouse selections land in SELECT mode (see easy-actions.lua:
    -- keymodel=startsel, selectmode=key,mouse), so the select-mode variants
    -- must be translated to their visual equivalents.
    local sel_motion = {
      v = 'v', V = 'V', ['\22'] = '\22',   -- visual, visual-line, visual-block
      s = 'v', S = 'V', ['\19'] = '\22',   -- select, select-line, select-block
    }

    local function toggle_selection(kind)
      -- Read the mode BEFORE leaving it; fall back to visualmode() for the case
      -- where which-key already dropped us back to normal mode with the
      -- selection left in the '< and '> marks.
      local motion = sel_motion[vim.fn.mode()] or vim.fn.visualmode()
      vim.api.nvim_feedkeys(esc, 'nx', false)
      api.toggle[kind](motion)
    end

    local map = vim.keymap.set
    -- VISUAL + SELECT: operate on the selection
    map({ 'x', 's' }, '<leader>/',  function() toggle_selection('linewise') end,
      { desc = 'Toggle comment (selection)' })
    map({ 'x', 's' }, '<leader>gc', function() toggle_selection('linewise') end,
      { desc = 'Toggle line comment (selection)' })
    map({ 'x', 's' }, '<leader>gb', function() toggle_selection('blockwise') end,
      { desc = 'Toggle block comment (selection)' })
    -- NORMAL: operate on the current line
    map('n', '<leader>/', api.toggle.linewise.current,
      { desc = 'Toggle comment (line)' })
  end
}
