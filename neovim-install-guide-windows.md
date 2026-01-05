# Neovim 2025 Setup - Windows Installation

## Prerequisites Installation

1. Install Neovim:
   ```powershell
   winget install Neovim.Neovim
   ```

2. Install Git:
   ```powershell
   winget install Git.Git
   ```

3. Install C compiler (required for Treesitter):
   - Download MSYS2 from https://www.msys2.org/
   - Run the installer (keep default path `C:\msys64`)
   - Open "MSYS2 MSYS" from Start Menu and run these commands in sequence:
     ```bash
     # Update package ypackages
     pacman -Syu
     # Close the terminal when asked and reopen "MSYS2 MSYS", then run:
     pacman -Su
     # Install GCC
     pacman -S mingw-w64-x86_64-gcc
     ```
   - Add to System PATH:
     1. Open Settings → System → About → Advanced system settings
     2. Click "Environment Variables"
     3. Under "System Variables", find and select "Path"
     4. Click "New" and add: `C:\msys64\mingw64\bin`
     5. Click "OK" to save all changes
   - Verify installation:
     1. Open a new terminal
     2. Run: `gcc --version`
   
   If using microsoft visual studio, the folder containing cl.exe should be in the path 
   "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64"

4. Install LazyGit:
   ```powershell
   winget install JesseDuffield.lazygit
   ```

5. Install Node.js (for LSP):
   ```powershell
   winget install OpenJS.NodeJS.LTS
   ```
   after this installation, node package manager npm should be in the path.
   install yarn with 
   ```powershell
   npm install -g yarn
   ```
   install tree-sitter-cli (tool for grammar parsing, required for treesitter within neovim) with 
   ```powershell
   npm install -g tree-sitter-cli
   ```
   install neovim node component 
   ```powershell
   npm install -g neovim
   ```
   

6. Install Python, py launcher and pip:
   (for max compatibility we suggest python 3.12)
   ```powershell
   winget install Python.Python.3.12
   ```
   after installation, py launcher should be in the path, 
   allowing to launch any python version that has been installed
   We prepare a dedicated venv for neovim, in our windows user folder
   we upgrade pip and install pynvim and neovim python packages
   ```powershell
   py -3.12 -m venv $env:USERPROFILE/venv_neovim
   . $env:USERPROFILE\venv_neovim\Scripts\Activate.ps1
   python -m pip install pip --upgrade
   python -m pip install pynvim neovim
   ```  


7. Install other tools:
   chocolatey
   ```powershell
   winget install chocolatey
   ```
   then open command prompt in admin mode, and install tools using chocolatey
   ```powershell
   choco install less grep gzip unzip make cmake curl wget fd 
   choco install fzf ripgrep bat mc far exiftool ffmpeg xxd
   ```
   7zip
   ```powershell
   winget install 7zip.7zip
   ```
   add the 7zip folder where 7z.exe is to the path, so that 7z can be run from command line
   

## go toolchain installation

this may be needed to support lsp plugins natively written in go, like sqls
for these tools to work, neovim must be aware of a local go compiler availability

Open https://go.dev/dl/ and install go for windows. 
By default this goes in c:/program files/go

You can just use winget to install go:
```powershell
   winget install Golang.go
```
the go installer automatically alters the path when installation is complete
checkhealth will detect its availability, and MasonInstall sqls will work





## Nerd Font Installation

these fonts allow use of many characters and symbols/icons that are very
useful when working with text based software, like neovim. Use of a nerd
font on windows is highly recommended to get the best from command line tools.
Configuration of the specific font is typically done in the windows 
terminal software which is where you run powershell and nvim and othe 
text tools.

1. Download Hack Nerd Font:
   - Visit: https://github.com/ryanoasis/nerd-fonts/releases/latest
   - Download `Hack.zip`

2. Extract and Install:
   - Extract the ZIP file
   - Select all `.ttf` files
   - Right-click → Install for all users

## Neovim Configuration Setup

### File Structure
```
%LOCALAPPDATA%\nvim\
├── init.lua
└── lua\
    └── config\
        ├── lazy.lua
        ├── colors.lua        
        ├── keymaps.lua
        └── languages.lua
```

### Installation Steps

For windows, you can git clone the github repo, replacing the 
c:\users\<user>\Appdata\Local\nvim with the contents from github
(The folder has to be empty for the git clone to succeed)
   ```powershell
   cd $env:LOCALAPPDATA\nvim
   git clone https://github.com/mgua/mg-nvim-2025.git .
   ```

1. Create directory structure: (not needed if you git cloned)
   ```powershell
   New-Item -Path $env:LOCALAPPDATA\nvim\lua\config -ItemType Directory -Force
   ```

2. Copy configuration files: (not needed if you git cloned)
   ```powershell
   # Assuming files are in current directory
   Copy-Item init.lua $env:LOCALAPPDATA\nvim\
   Copy-Item lazy.lua $env:LOCALAPPDATA\nvim\lua\config\
   Copy-Item keymaps.lua $env:LOCALAPPDATA\nvim\lua\config\
   Copy-Item colors.lua $env:LOCALAPPDATA\nvim\lua\config\
   Copy-Item languages.lua $env:LOCALAPPDATA\nvim\lua\config\
   ```

## Neovim plugins

Neovim supports many plugin managers: software that allow extended 
functionalities. We will use lazy, which is one of the best supported
plugin managers. When using Lazy, you configure the plugins you want 
to install in a configuration file (lazy.lua in our case). 

Some plugins provide functionality only when they interact with other plugins

- mason: is used to activate LSP (language server protocol) 
It typically relies on a preexisting nodejs installation and on a number 
of node packages installed via npm (node package manager)

- mason-lspconfig: this plugin allows to "bridge" Mason with nvim-lspconfig 
providing a mason friendly interface for LSP components

- nvim-lspconfig: this plugin allows to centralize configurations of several
language servers

- Treesitter: syntax server/colorizer/linter
Use TSInstall <TAB> to add components: 
```
TSInstall html css powershell
```

- Telescope: fuzzy finder, searches for text across files and folders
https://github.com/nvim-telescope/telescope.nvim
requires ripgrep, fd, devicons, fzf
use :checkhealth to validate setup
use :Telescope find_files to validate working


## Windows Terminal Configuration

1. Open Settings (Ctrl+,)
2. Select your profile (Windows PowerShell, Command Prompt, etc.)
3. Under "Appearance":
   - Set "Font face" to "Hack Nerd Font" or "Hack Nerd Font Mono"
   - Set "Font size" to 12 (or preferred size)
   - Enable "Use acrylic"
   - Set "Acrylic opacity" to 0.9 for better readability
4. Under "Color Schemes":
   - Consider using "One Half Dark" or "Tokyo Night"
5. Under "Additional Settings":
   - Enable "Use Unicode UTF-8 for worldwide language support"

## First Launch Setup

1. Start Neovim:
   ```powershell
   nvim
   ```

2. Wait for automatic installation of:
   - Lazy.nvim (plugin manager)
   - All configured plugins
   - LSP servers via Mason

3. Install LSP servers:
   pyright is not to be used. 
   basedpyright is the good one
   basedpyright requires python and it may need some trials to have it work
   I succeded in launching neovim from the venv_neovim in which i previously installed it
   and then relaunching install from :Mason
   Apparently this is needed only the first time. Later basedpyright is reinstalled inside 
   its own dedicated environment
   ```
   . $env:USERPROFILE\venv_neovim\Scripts\Activate.ps1
   python -m pip install basedpyright
   ```
   here are the command lines to install all the language server components.
   sqls depends from go (needs a go compiler available)
   A slightly less powerful lsp server is sql-language-server which is in node.js
   ```
   :MasonInstall basedpyright lua-language-server json-lsp marksman intelephense yaml-language-server
   # :MasonInstall sqls sqlfluff sql-language-server
   :MasonInstall sqls sqlfluff 
   :MasonInstall typescript-language-server html-lsp css-lsp prettier eslint_d
   ```

4. Install Treesitter parsers: (requires compiler, as it is requested for treesitter itself)
   ```
   :TSInstall python lua json yaml markdown sql html css powershell 
   ```
   To validate treesitter, pressing :TS should show many available commands, selectable by <TAB>
   You can manually start treesitter with the following command:
   ```
   :lua vim.treesitter.start()
   ```
   Once treesitter is started, pressing :TS<TAB> should allow you to see a richer option list

5. Verify installation:
   ```
   :checkhealth
   :Mason
   :Lazy
   :TSInstallInfo
   ```

## Path Verification

After installation, verify these paths exist:
1. Neovim config:
   ```powershell
   dir $env:LOCALAPPDATA\nvim
   ```
2. Plugins:
   ```powershell
   dir $env:LOCALAPPDATA\nvim-data\lazy
   ```
3. LSP servers:
   ```powershell
   dir $env:LOCALAPPDATA\nvim-data\mason
   ```

## Updating

1. Update Neovim:
   ```powershell
   winget upgrade Neovim.Neovim
   ```

2. Update plugins:
   ```
   :Lazy update
   ```

3. Update LSP servers:
   ```
   :MasonUpdate
   ```

4. Update Treesitter parsers:
   ```
   :TSUpdate
   ```


## key mappings

nvim starts in **normal mode**

HJKL control cursor movement in normal mode and visual mode
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

