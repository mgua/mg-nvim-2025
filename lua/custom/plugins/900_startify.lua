-- the classical startify
-- this is in lazy plugin manager format


return {
    'mhinz/vim-startify',
    config = function()
      vim.notify('loading startify...', vim.log.levels.INFO)
      -- Custom header
      -- vim.g.startify_custom_header = {
      --  '   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
      --  '   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
      --  '   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
      --  '   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
      --  '   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
      --  '   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
      -- }
      -- Configure session directory
      vim.g.startify_session_dir = vim.fn.stdpath('data')..'/session'
      -- Custom lists
      vim.g.startify_lists = {
        { type = 'files',     header = {'   Recent Files'}},
        { type = 'sessions',  header = {'   Sessions'}},
        { type = 'bookmarks', header = {'   Bookmarks'}},
      }
      -- Custom bookmarks
      vim.g.startify_bookmarks = {
        { c = '~/.config/nvim/init.lua' },
        { p = '~/projects' },
      }
      -- Other settings
      vim.g.startify_session_autoload = 1    -- Automatically load session if one exists
      vim.g.startify_session_persistence = 1  -- Automatically update sessions
      vim.g.startify_change_to_vcs_root = 1  -- Change to project root
      vim.g.startify_fortune_use_unicode = 1  -- Use Unicode box drawing characters
      vim.g.startify_enable_special = 0      -- Don't show <empty buffer> and <quit>
    end
  }

