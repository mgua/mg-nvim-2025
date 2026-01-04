-- Hex editing with hex.nvim
-- https://github.com/RaafatTurki/hex.nvim
--
-- This plugin provides hex editing capabilities using xxd
-- Prerequisites:
--   Windows: xxd comes with vim/neovim, or install via:
--            scoop install xxd  OR  choco install xxd
--            Also included in Git for Windows (git bash)
--   Linux: xxd is usually included with vim, or: sudo apt install xxd
--   macOS: xxd comes with vim, or: brew install vim (includes xxd)
--
-- Commands:
--   :HexDump     - Convert buffer to hex view
--   :HexAssemble - Convert hex view back to binary
--   :HexToggle   - Toggle between hex and normal view
--
-- Keymaps (after loading):
--   <leader>hx   - Toggle hex view
--   <leader>hd   - Hex dump (to hex)
--   <leader>hr   - Hex reassemble (to binary)

return {

  {
    'RaafatTurki/hex.nvim',
    cmd = { 'HexDump', 'HexAssemble', 'HexToggle' },
    keys = {
      { '<leader>hx', desc = 'Hex toggle' },
      { '<leader>hd', desc = 'Hex dump' },
      { '<leader>hr', desc = 'Hex reassemble' },
    },

    config = function()
      -- Check for xxd availability
      local has_xxd = vim.fn.executable('xxd') == 1

      if not has_xxd then
        vim.notify(
          "hex.nvim: xxd not found!\n" ..
          "Please install xxd:\n" ..
          "  Windows: scoop install xxd  OR  choco install xxd\n" ..
          "           (also included in Git for Windows)\n" ..
          "  Linux:   sudo apt install xxd (or equivalent)\n" ..
          "  macOS:   brew install vim (includes xxd)",
          vim.log.levels.WARN
        )
        -- Continue setup anyway - user might install xxd later
      end

      require('hex').setup({
        -- dump_cmd = 'xxd -g 1 -u',        -- custom xxd command (optional)
        -- assemble_cmd = 'xxd -r',         -- custom reassemble command (optional)
        is_file_binary_pre_read = function()
          -- Auto-detect binary files before reading
          -- Returns true if file should be opened in hex mode
          local binary_ext = {
            'bin', 'exe', 'dll', 'so', 'dylib', 'o', 'obj',
            'dat', 'img', 'iso', 'rom', 'fw', 'eep', 'hex'
          }
          local filename = vim.fn.expand('%:e'):lower()
          for _, ext in ipairs(binary_ext) do
            if filename == ext then
              return true
            end
          end
          return false
        end,
        is_file_binary_post_read = function()
          -- Check if file contains binary data after reading
          -- Look for null bytes in first 1000 chars
          local lines = vim.api.nvim_buf_get_lines(0, 0, 1, false)
          if #lines > 0 and lines[1]:find('\0') then
            return true
          end
          return false
        end,
      })

      -- Set up keymaps
      vim.keymap.set('n', '<leader>hx', '<cmd>HexToggle<cr>', 
        { desc = 'Hex toggle', silent = true })
      vim.keymap.set('n', '<leader>hd', '<cmd>HexDump<cr>', 
        { desc = 'Hex dump', silent = true })
      vim.keymap.set('n', '<leader>hr', '<cmd>HexAssemble<cr>', 
        { desc = 'Hex reassemble', silent = true })

      vim.notify('hex.nvim loaded' .. (has_xxd and '' or ' (xxd not found!)'), 
        vim.log.levels.INFO)
    end,
  },

}

