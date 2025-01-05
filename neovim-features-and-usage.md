# Neovim Modern Setup - Part 2: Features and Usage

## Key Features and Mappings

### Start Screen (Startify)

#### Session Management
- `<leader>ss` - Save current session
- `<leader>sl` - Load session
- `<leader>sd` - Delete session
- `<leader>sc` - Close current session

#### Inside Start Screen Navigation
Basic Movement:
- `j/k` - Move cursor up/down
- `gg/G` - Go to top/bottom
- `<CR>` or `e` - Open file/session
- `q` - Quit start screen

Opening Options:
- `e` - Edit file (keeps start screen)
- `t` - Open in new tab
- `h` - Open in horizontal split
- `v` - Open in vertical split
- `gf` - Go to file's directory

Session Operations:
- `s` - Jump to sessions section
- `x` - Delete session under cursor
- `S` - Source Vim/Neovim file

List Navigation:
- `b` - Jump to bookmarks section
- `<Tab>` - Next section/list
- `<S-Tab>` - Previous section/list
- `R` - Reload/refresh screen

Advanced Features:
- `<C-f>` - Find files (respects .gitignore)
- `i` - Display file info
- `B` - Open list in new tab

#### Command Mode Operations
- `:SLoad [name]` - Load session
- `:SSave [name]` - Save session
- `:SDelete [name]` - Delete session
- `:SClose` - Close session
- `:Startify` - Open start screen
- `:StartifyBookmark` - Add current file to bookmarks

#### Session Directory Locations
- Windows: `%LOCALAPPDATA%\nvim-data\session`
- Linux: `~/.local/share/nvim/session`

#### Tips for Startify Use
1. Session Management:
   - Sessions auto-save on exit if previously saved
   - Use meaningful session names for projects
   - Sessions save: buffers, windows, tabs, and working directory

2. Bookmarks:
   - Can use both absolute and relative paths
   - Support environment variables
   - Can include terminal commands

3. Start Screen:
   - Numbers/letters in brackets are shortcuts
   - Lists are customizable in config
   - Header is customizable in config

4. Project Detection:
   - Automatically detects Git repositories
   - Changes working directory to project root
   - Maintains separate MRU lists per project

### File Explorer (nvim-tree)
- `<C-n>` - Toggle file explorer
- `<leader>e` - Focus file explorer

In the file explorer:
- `a` - Create new file/directory
- `d` - Delete file/directory
- `r` - Rename file/directory
- `x` - Cut file/directory
- `c` - Copy file/directory
- `p` - Paste file/directory
- `R` - Refresh tree
- `H` - Toggle hidden files

### Markdown Preview
- `<leader>mp` - Toggle markdown preview in browser
- `:MarkdownPreview` - Start preview
- `:MarkdownPreviewStop` - Stop preview

Commands available in markdown files:
- `:MarkdownPreviewToggle` - Toggle preview window
- `:MarkdownPreview` - Start preview
- `:MarkdownPreviewStop` - Stop preview

Tips:
- Preview opens in your default browser
- Live updates as you type
- Supports GitHub-flavored markdown
- Automatically closes preview when leaving buffer
- Supports code syntax highlighting
- Math equations (KaTeX) support
- Emoji support

### Git Integration
- `<leader>gg` - Open LazyGit
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage buffer
- `<leader>hu` - Undo stage hunk
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line
- `]c` - Next hunk
- `[c` - Previous hunk

### LSP Features
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

### Clipboard Operations
- `<leader>y` - Copy to system clipboard
- `<leader>p` - Paste from system clipboard
- OSC52 enabled for remote clipboard support

## Troubleshooting

1. If you see boxes instead of icons:
   - Verify Nerd Font installation
   - Confirm terminal is using the Nerd Font
   - Restart your terminal

2. If clipboard isn't working in remote sessions:
   - Confirm your terminal supports OSC52
   - Check that the remote server can connect to your local machine
   - Verify OSC52 settings in your terminal

3. If LSP isn't working:
   - Run `:Mason` and check if servers are installed
   - Run `:LspInfo` to check server status
   - Verify Node.js installation: `node --version`

4. If Treesitter gives C compiler errors:
   - Verify GCC installation: `gcc --version`
   - Check if `C:\msys64\mingw64\bin` is in your PATH (Windows)
   - Try reinstalling gcc via MSYS2 if needed

5. If Startify sessions aren't saving:
   - Check if session directory exists
   - Verify write permissions
   - Try manual save with `:SSave session_name`
   - Check session path in error message
   - Try creating session directory manually
   - Verify no path contains spaces

6. Common Git integration issues:
   - Ensure git is installed and available in PATH
   - Run `:checkhealth` to verify plugin status
   - For LazyGit, verify installation: `lazygit --version`

## Additional Resources

1. Plugin Documentation:
   - Startify: https://github.com/mhinz/vim-startify
   - Nvim-tree: https://github.com/nvim-tree/nvim-tree.lua
   - LSP Zero: https://github.com/VonHeikemen/lsp-zero.nvim
   - LazyGit: https://github.com/kdheepak/lazygit.nvim
   - OSC52: https://github.com/ojroques/nvim-osc52

2. Neovim Help:
   - `:help` - General help
   - `:checkhealth` - System diagnostics
   - `:Mason` - LSP server management
   - `:Lazy` - Plugin management
   - `:help startify` - Startify documentation
   - `:help startify-commands` - All Startify commands