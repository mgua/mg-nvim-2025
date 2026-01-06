-- this is https://github.com/iamcco/markdown-preview.nvim

return {

  {
  -- Markdown Preview you need npm and yarn
  -- prereqs for windows: winget install  OpenJS.NodeJS.LTS
  --                      npm install -g yarn
  --
  -- this code has been improved by mgua@tomware.it and claude, because
  -- To make it work on Windows, I had to open a powershell window, then go to
  -- C:\Users\<USER>\AppData\Local\nvim-data\lazy\markdown-preview.nvim\app
  -- then run
  --    yarn install
  -- After this, from neovim, open a markdown (.md) file and give command
  -- :Markdown-Preview had it working (CAUTION: a .md file NEEDS to be loaded)
  --
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },

    build = function(plugin)
      -- Get plugin installation directory
      local plugin_dir = plugin.dir
      if not plugin_dir then
        plugin_dir = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim"
      end
      local app_dir = plugin_dir .. "/app"

      -- Check if app directory exists
      if vim.fn.isdirectory(app_dir) == 0 then
        vim.notify(
          "markdown-preview: app directory not found at:\n" .. app_dir,
          vim.log.levels.ERROR
        )
        return
      end

      -- Check for yarn or npm availability (prefer yarn)
      local has_yarn = vim.fn.executable('yarn') == 1
      local has_npm = vim.fn.executable('npm') == 1

      if not has_yarn and not has_npm then
        vim.notify(
          "markdown-preview: Neither yarn nor npm found!\n" ..
          "Please install Node.js and yarn:\n" ..
          "  Windows: winget install OpenJS.NodeJS.LTS && npm install -g yarn\n" ..
          "  Linux: sudo apt install nodejs yarn (or equivalent)\n" ..
          "  macOS: brew install node yarn",
          vim.log.levels.ERROR
        )
        return
      end

      local install_cmd = has_yarn and "yarn install" or "npm install"
      local cmd

      if vim.fn.has('win32') == 1 then
        -- Windows: use cd /d to handle drive changes, wrap path in quotes
        cmd = string.format('cd /d "%s" && %s', app_dir, install_cmd)
      else
        -- Linux/macOS
        cmd = string.format('cd "%s" && %s', app_dir, install_cmd)
      end

      vim.notify(
        "markdown-preview: Running build with " .. (has_yarn and "yarn" or "npm") .. "...",
        vim.log.levels.INFO
      )

      -- Run the install command
      local result = vim.fn.system(cmd)

      -- Check for errors
      if vim.v.shell_error ~= 0 then
        vim.notify(
          "markdown-preview: Build failed!\n" ..
          "Command: " .. cmd .. "\n" ..
          "Error: " .. result,
          vim.log.levels.ERROR
        )
      else
        vim.notify("markdown-preview: Build completed successfully!", vim.log.levels.INFO)
      end
    end,

    config = function()
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


