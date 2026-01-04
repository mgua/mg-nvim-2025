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
--
-- Limitations:
--   Files larger than 16MB are blocked to prevent memory issues.
--   For large binary files, use external hex editors (HxD, ImHex, hexedit).

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
      -- Maximum file size for hex editing (16 MB)
      local MAX_FILE_SIZE = 16 * 1024 * 1024

      -- Helper: check file size, return true if within limit
      local function check_file_size(filepath)
        if not filepath or filepath == '' then
          filepath = vim.fn.expand('%:p')
        end
        if filepath == '' then
          return true  -- new buffer, allow
        end
        local size = vim.fn.getfsize(filepath)
        if size > MAX_FILE_SIZE then
          vim.notify(
            string.format(
              "hex.nvim: File too large (%.1f MB)\n" ..
              "Maximum allowed: %.0f MB\n" ..
              "Use external hex editor (HxD, ImHex, hexedit) for large files.",
              size / 1024 / 1024,
              MAX_FILE_SIZE / 1024 / 1024
            ),
            vim.log.levels.WARN
          )
          return false
        end
        return true
      end

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
      end

      require('hex').setup({
        is_file_binary_pre_read = function()
          -- Check file size first
          local filepath = vim.fn.expand('%:p')
          if not check_file_size(filepath) then
            return false  -- don't auto-open in hex mode
          end

          -- Auto-detect binary files by extension
          local binary_ext = {
            'bin', 'exe', 'dll', 'so', 'dylib', 'o', 'obj',
            'dat', 'img', 'iso', 'rom', 'fw', 'eep', 'hex'
          }
          local ext = vim.fn.expand('%:e'):lower()
          for _, binary in ipairs(binary_ext) do
            if ext == binary then
              return true
            end
          end
          return false
        end,

        is_file_binary_post_read = function()
          -- Check file size first
          if not check_file_size() then
            return false
          end

          -- Check if file contains binary data (null bytes)
          local lines = vim.api.nvim_buf_get_lines(0, 0, 1, false)
          if #lines > 0 and lines[1]:find('\0') then
            return true
          end
          return false
        end,
      })

      -- Wrapped commands with size check
      local function safe_hex_cmd(cmd)
        return function()
          if check_file_size() then
            vim.cmd(cmd)
          end
        end
      end

      -- Set up keymaps with size protection
      vim.keymap.set('n', '<leader>hx', safe_hex_cmd('HexToggle'),
        { desc = 'Hex toggle', silent = true })
      vim.keymap.set('n', '<leader>hd', safe_hex_cmd('HexDump'),
        { desc = 'Hex dump', silent = true })
      vim.keymap.set('n', '<leader>hr', '<cmd>HexAssemble<cr>',
        { desc = 'Hex reassemble', silent = true })

      vim.notify('hex.nvim loaded (max file size: 16MB)' ..
        (has_xxd and '' or ' [xxd not found!]'),
        vim.log.levels.INFO)
    end,
  },

}

