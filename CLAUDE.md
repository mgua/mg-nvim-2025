# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

A Neovim 0.12+ configuration for multiplatform use (Linux and Windows). It is not a software project with build/test pipelines — there are no build commands, no test suite, and no package.json/Makefile. Changes are applied by restarting Neovim or sourcing files directly.

## Repository Structure

```
init.lua                    # Entry point: sets options, bootstraps lazy.nvim, loads config modules
init-lite.lua               # Self-contained single-file minimal alternative config
lua/config/                 # Core config modules loaded by init.lua
lua/custom/plugins/         # Plugin specs for lazy.nvim (numbered for load order)
templates/                  # Project config templates (pyrightconfig, pyproject.toml, etc.)
```

## Load Order (init.lua)

1. `easy-actions.lua` — mouse, clipboard (OSC52 on Linux, native on Windows), Ctrl+C/V/X
2. `venv-selector.lua` — Python venv auto-detection
3. `first-keymaps.lua` — buffer/tab/window navigation
4. `lazy.lua` — loads all plugins from `lua/custom/plugins/*.lua`
5. `colors.lua` — VS Code-like color overrides on top of onedark theme
6. `lsp.lua` — LSP diagnostic config and server-specific settings
7. `last-keymaps.lua` — file explorer, lazygit, markdown preview, merge tools

## Plugin Files

Numbered files in `lua/custom/plugins/` control load order. Key ones:
- `200_mason.lua` — Mason LSP package manager + LSP keymaps (`gd`, `K`, `<leader>rn`, etc.)
- `400_codecompanion.lua` — AI assistant via local Ollama (keymaps: `<leader>a*`)
- `100_treesitter.lua` — syntax/folding; bundled parsers in nvim 0.11, rest via plugin

## Platform Differences

Detected via `vim.fn.has('win32')`:
- **Linux**: clipboard via OSC52 (tmux-friendly), Python venv at `~/.venv_neovim`
- **Windows**: native clipboard, venv at `%USERPROFILE%/venv_neovim`

## LSP Setup

Uses native Neovim 0.11 `vim.lsp` API (not lspconfig). Mason manages: bash, powershell, lua, PHP, SQL, HTML, CSS. `basedpyright` is installed externally via npm.

The Python venv selector (`lua/config/venv-selector.lua`) auto-detects venvs named `venv_<projectname>` and restarts basedpyright when the venv changes.

## Documentation

- `readme.md` — overview and treesitter network share workaround
- `install-guide-linux.md` / `install-guide-windows.md` — setup instructions
- `neovim-features-and-usage.md` — component descriptions
- `troubleshooting.md` — common issues
