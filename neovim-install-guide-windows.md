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
     # Update package database and base packages
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
   choco install less grep gzip unzip make cmake curl wget fd fzf ripgrep bat mc far exiftool ffmpeg
   ```
   7zip
   ```powershell
   winget install 7zip.7zip
   ```
   add the 7zip folder where 7z.exe is to the path, so that 7z can be run from command line
   

## Nerd Font Installation

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
   ```
   python -m pip install basedpyright
   ```
   here are the command lines to install all the language server components.
   sqls depends from go (needs a go compiler available)
   A slightly less powerful lsp server is sql-language-server which is in node.js
   ```
   :MasonInstall basedpyright lua-language-server json-lsp marksman intelephense yaml-language-server
   # :MasonInstall sqls sqlfluff sql-language-server
   :MasonInstall sql-language-server sqlfluff 
   :MasonInstall typescript-language-server html-lsp css-lsp prettier eslint_d
   ```

4. Install Treesitter parsers: (requires compiler, as it is requested for treesitter itself)
   ```
   :TSInstall python lua json yaml markdown sql 
   ```

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
