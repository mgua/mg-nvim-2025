-- automatic venv-selector mgua+claude dec 2025 / jan 2026
-- Auto-detect venv based on project structure
-- Looks for venv_<projectname> one level up from project root
-- If not found, prompts user to select from available venvs
-- this is for neovim, and it is invoked from init.lua
--
-- Updated for Neovim 0.11+: uses native LSP API instead of lspconfig commands

vim.notify("python venv-selector...", vim.log.levels.INFO)

-- Cross-platform helpers
local is_windows = vim.fn.has("win32") == 1
local path_sep = is_windows and "\\" or "/"
local venv_bin = is_windows and "Scripts" or "bin"
local python_exe = is_windows and "python.exe" or "python"

local function get_python_path(venv_path)
    return venv_path .. path_sep .. venv_bin .. path_sep .. python_exe
end

local function restart_basedpyright()
    -- Neovim 0.11+: stop client, it will auto-restart via vim.lsp.enable()
    local clients = vim.lsp.get_clients({ name = "basedpyright" })
    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
    end
    -- Trigger re-attach by re-entering buffer
    vim.defer_fn(function()
        vim.cmd("edit")
    end, 100)
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*.py",
    callback = function()
        -- Skip if venv already set for this session
        if vim.g.venv_selected then return end

        local root = vim.fs.root(0, { ".git", "pyrightconfig.json", "pyproject.toml", "setup.py" })
        if not root then return end

        local project_name = vim.fn.fnamemodify(root, ":t")
        local parent_dir = vim.fn.fnamemodify(root, ":h")
        local venv_path = parent_dir .. path_sep .. "venv_" .. project_name

        local function set_venv(path)
            local python_path = get_python_path(path)
            if vim.fn.filereadable(python_path) == 0 then
                vim.notify("Python not found in: " .. path, vim.log.levels.ERROR)
                return
            end

            vim.env.VIRTUAL_ENV = path
            vim.env.PATH = path .. path_sep .. venv_bin .. (is_windows and ";" or ":") .. vim.env.PATH
            vim.g.venv_selected = path

            -- Update basedpyright config with new python path
            local clients = vim.lsp.get_clients({ name = "basedpyright" })
            for _, client in ipairs(clients) do
                client.config.settings.python = client.config.settings.python or {}
                client.config.settings.python.pythonPath = python_path
                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end

            -- Restart LSP to pick up new venv (Neovim 0.11+ method)
            vim.defer_fn(function()
                restart_basedpyright()
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
                    table.insert(venvs, parent_dir .. path_sep .. name)
                end
            end
        end

        if #venvs == 0 then
            vim.notify("No venv_* folders found in: " .. parent_dir, vim.log.levels.WARN)
            return
        end

        -- Auto-select if matching venv exists
        for _, venv in ipairs(venvs) do
            if venv == venv_path then
                set_venv(venv)
                return
            end
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
