-- automatic venv-selector mgua+claude dec 2025
-- Auto-detect venv based on project structure
-- Looks for venv_<projectname> one level up from project root
-- If not found, prompts user to select from available venvs
-- this is for neovim, and it is invoked from init.lua

vim.notify("python venv-selector...", vim.log.levels.INFO)
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*.py",
  callback = function()
    -- Skip if venv already set for this session
    if vim.g.venv_selected then return end

    local root = vim.fs.root(0, { ".git", "pyrightconfig.json", "pyproject.toml", "setup.py" })
    if not root then return end

    local project_name = vim.fn.fnamemodify(root, ":t")
    local parent_dir = vim.fn.fnamemodify(root, ":h")
    local venv_path = parent_dir .. "/venv_" .. project_name
    local venv_python = venv_path .. "/Scripts/python.exe"

    local function set_venv(path)
      local python_exe = path .. "/Scripts/python.exe"
      if vim.fn.filereadable(python_exe) == 0 then
        vim.notify("Python not found in: " .. path, vim.log.levels.ERROR)
        return
      end

      vim.env.VIRTUAL_ENV = path
      vim.env.PATH = path .. "/Scripts;" .. vim.env.PATH
      vim.g.venv_selected = path

      -- Restart basedpyright with new python path
      local clients = vim.lsp.get_clients({ name = "basedpyright" })
      for _, client in ipairs(clients) do
        client.config.settings.python = { pythonPath = python_exe }
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end

      -- Force LSP restart to pick up new venv
      vim.defer_fn(function()
        vim.cmd("LspRestart basedpyright")
      end, 100)

      vim.notify("Activated venv: " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO)
    end

    -- Find all venv_* folders in parent directory
    local venvs = {}
    local handle = vim.loop.fs_scandir(parent_dir)
    if handle then
      while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end
        if type == "directory" and name:match("^venv_") then
          table.insert(venvs, parent_dir .. "/" .. name)
        end
      end
    end

    if #venvs == 0 then
      vim.notify("No venv_* folders found in: " .. parent_dir, vim.log.levels.WARN)
      return
    end

    -- Prompt user to select a venv
    vim.ui.select(venvs, {
      prompt = "Select venv for " .. project_name .. ":",
      format_item = function(item)
        return vim.fn.fnamemodify(item, ":t")
      end,
    }, function(choice)
      if choice then
        set_venv(choice)
      end
    end)
  end,
})

