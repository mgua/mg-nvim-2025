# Neovim Modern Setup - Features and Usage

## Quick vim/neovim introduction

nvim is a modal editor. it has several operation modes, 

Each mode has a different behaviour. 
Active mode is shown in a colored marker in the lower left of the active window
NORMAL / INSERT / COMMAND / VISUAL / VISUAL-LINE / VISUAL-BLOCK

nvim starts in **normal mode**

HJKL (and cursor keys) control cursor movement in normal mode and visual mode
i from normal mode goes to **insert mode** 
v from normal mode goes to **visual mode** (this is the char selection mode)
V from normal mode goes to **v-line visual mode** (this is the line selection mode)

<ALT>+mouse click goes to **visual block mode** (column select mode) 
(traditionally this was associated to CTRL-V, conflicting with clipboard paste)

u from normal mode performs UNDO
<CTRL>-R from normal mode performs REDO

<ESC> goes back to **normal mode**
: from normal mode goes into **command mode**

:w writes current edit buffer
:q exit
:wq! save and exit immediately

in normal mode, yy yanks (copies) the current line to the default clipboard
in normal mode, p pops (pastes) the default clipboard contents

:/pattern searches for patter. n for next, N for previous. Occurrence count in bottom right
:87 goes to line 87
G87 from normal mode goes to line 87
:1 go to first line
<CTRL>-O goes back to the previous position in jump list
:$ go to last line
:h helptopic opens neovim help.
When having relative numbers, you can see line distance from current line.
from normal mode 5yy copies the next 5 lines
from normal mode 5dd deletes the next 5 lines
from normal mode dd deletes current line
from normal mode mk sets marker k (bookmark) at current position. markers can be a..z
from normal mode 'k goes to marker k (you may see markers list) 


cursor movement in normal mode:
^ beginning of line
$ end of line
G to to last line
gg go to first line

<CTRL>-hjkl (movement keys)

A command combination to copy all the file content:
<ESC>ggvGy	)goto normal mode, goto 1st line, enter visual mode (select), go to last line, and yank

some dedicated keymaps are plugin specific, as an example <leader>h has some suboptions for hex plugin


While in help, undelined links can be opened with mouse double left click or with <CTRL>-]
to go back use <CTRL>-T or <CTRL>-O

when in multiwindow, use CTRL-ww to cycle across window, from normal mode


<leader> is defined as SPACEBAR
<leader>t toggle file navigator (Nvtreetoggle)
:
in normal mode:
nyy OR n<leader>y OR n<leader>c copies subsequent n lines to clipboard
(also works from remote sessions over ssh within windows terminal)

in insert mode:
shift-INS or CTRL-V: paste from clipboard 

<ESC>wq! close with save


### window operations

CTRL-w T (move current window in a dedicated TAB page)
CTRL-W gt / CTRL-W gT (go to previous/next tab page)
CTRL-W s split current window horizontally
CTRL-W v split current window vertically
CTRL-W q closes current window

(TO BE COMPLETED)


## GIT integration

It is recommended to have a .gitcofig file in the user home folder, with the important git settings.

These settings can be written via git config commands, or you can directly edit the file contents.
Here is my **~/.gitconfig** with some edits

```
[user]
	email = username@domain.tld
	name = john smith
[filter "lfs"]
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
	required = true
	clean = git-lfs clean -- %f
[core]
	sshCommand = ssh -i c:/Users/<JSMITH>/.ssh/id_rsa_JSMITH
	editor = nvim
[merge]
	tool = nvimdiff
[mergetool "nvimdiff"]
	layout = (LOCAL,BASE,REMOTE)/MERGED
[credential "https://huggingface.co"]
	provider = generic
[init]
	defaultBranch = main
```



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
