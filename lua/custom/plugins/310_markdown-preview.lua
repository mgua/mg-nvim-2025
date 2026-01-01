-- this is https://github.com/iamcco/markdown-preview.nvim

return {

  {
  -- Markdown Preview you need npm and yarn
  -- windows: winget install  OpenJS.NodeJS.LTS
  --          npm install -g yarn 
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      if vim.fn.has('win32') == 1 then
          vim.fn.system('cmd.exe /c "cd app && npm install"')
      else
          vim.fn.system('cd app && npm install')
      end
    end,    

    config = function()
      vim.notify('loading markdown-preview...', vim.log.levels.INFO)
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ''  -- Use default browser
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_page_title = '「${name}」'
    end,
  },

}


