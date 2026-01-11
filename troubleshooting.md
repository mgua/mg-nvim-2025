# Neovim Setup - Troubleshooting Guide

## Common Issues and Solutions

### Font and Icon Issues
1. If you see boxes instead of icons:
   - Verify Nerd Font installation
     ```powershell
     # Windows: Check in Settings > Fonts
     # Linux: fc-list | grep "Hack"
     ```
   - Confirm terminal is using the Nerd Font
   - Restart your terminal
   - Try reinstalling the font

2. Font looks wrong in terminal:
   - Ensure you're using "Hack Nerd Font" or "Hack Nerd Font Mono"
   - Check if font size is appropriate for your display
   - Verify terminal supports true color: `echo $TERM`

### Clipboard Integration
1. If clipboard isn't working in remote sessions:
   - Confirm your terminal supports OSC52
   - Test basic clipboard: `echo "test" | clip.exe` (Windows) or `xclip` (Linux)
   - Check vim registers: `:reg "*` and `:reg "+"`
   - Verify OSC52 settings in your terminal

2. Local clipboard issues:
   - Check if vim was compiled with clipboard support: `:echo has('clipboard')`
   - Install xclip/xsel on Linux: `sudo apt install xclip`
   - Verify PATH includes clipboard utilities

### LSP Related Issues
1. If LSP isn't working:
   - Run `:Mason` and check if servers are installed
   - Run `:LspInfo` to check server status
   - Verify Node.js installation: `node --version`
   - Check LSP logs: `:LspLog`

2. Common LSP errors:
   ```
   No LSP server attached
   ```
   - Install language server: `:MasonInstall <server-name>`
   - Check if server is in PATH
   - Verify file type is correct: `:set filetype?`

### Treesitter Problems
1. If Treesitter gives C compiler errors:
   - Verify GCC installation: `gcc --version`
   - Check if `C:\msys64\mingw64\bin` is in your PATH (Windows)
   - Try reinstalling gcc via MSYS2:
     ```bash
     pacman -S mingw-w64-x86_64-gcc
     ```
   - Check Treesitter health: `:checkhealth nvim-treesitter`

2. Syntax highlighting issues:
   - Install parser: `:TSInstall <language>`
   - Update parser: `:TSUpdate`
   - Check installed parsers: `:TSInstallInfo`

### Startify Session Issues
1. If sessions aren't saving:
   - Check if session directory exists:
     ```bash
     # Windows
     dir %LOCALAPPDATA%\nvim-data\session
     # Linux
     ls ~/.local/share/nvim/session
     ```
   - Verify write permissions
   - Try manual save: `:SSave session_name`
   - Check session path in error message

2. Session loading problems:
   - Verify session file exists
   - Check for path issues (spaces, special characters)
   - Try creating session directory manually
   - Look for session conflicts

### Git Integration Problems
1. Common Git issues:
   - Ensure git is installed and in PATH: `git --version`
   - Run `:checkhealth` to verify plugin status
   - For LazyGit: `lazygit --version`

2. Gitsigns not showing:
   - Verify repository is valid: `git status`
   - Check if in .git directory
   - Reload buffer: `:e`

### Plugin Installation Issues
1. If Lazy.nvim fails:
   - Check internet connection
   - Verify git installation
   - Look for proxy issues
   - Check plugin installation logs: `:Lazy log`

2. Plugin specific issues:
   - Update all plugins: `:Lazy sync`
   - Check plugin status: `:Lazy`
   - Try cleaning and reinstalling: `:Lazy clean`

### Markdown Preview Problems
1. Preview not opening:
   - Check if browser is detected
   - Verify node.js installation
   - Try specifying browser manually in config
   - Check console for JavaScript errors

2. Live update not working:
   - Verify WebSocket connection
   - Check port availability
   - Try different browser

## Diagnostic Commands

### System Health Checks
```vim
:checkhealth
:checkhealth nvim-treesitter
:checkhealth lazy
```

### LSP Diagnostics
```vim
:LspInfo
:LspLog
:Mason
```

### Plugin Status
```vim
:Lazy
:TSInstallInfo
:StartifyDebug
```

## Additional Resources

1. Log Locations:
   - Neovim log: `:echo stdpath('cache')`/log
   - LSP logs: `:echo stdpath('cache')`/lsp.log
   - Plugin logs: `:echo stdpath('cache')`/lazy.nvim.log

2. Configuration Paths:
   - Config: `:echo stdpath('config')`
   - Data: `:echo stdpath('data')`
   - Cache: `:echo stdpath('cache')`

3. Helpful Commands:
   - `:version` - Show Neovim version and build info
   - `:messages` - Show message history
   - `:scriptnames` - List all loaded scripts


