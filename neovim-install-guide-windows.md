# Neovim Modern Setup - Windows Installation

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

4. Install LazyGit:
   ```powershell
   winget install JesseDuffield.lazygit
   ```

5. Install Node.js (for LSP):
   ```powershell
   winget install OpenJS.NodeJS.LTS
   ```

6. Install Python and pip:
   ```powershell
   winget install Python.Python.3.11
   ```

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
        ├── keymaps.lua
        └── languages.lua
```

### Installation Steps

1. Create directory structure:
   ```powershell
   New-Item -Path $env:LOCALAPPDATA\nvim\lua\config -ItemType Directory -Force
   ```

2. Copy configuration files:
   ```powershell
   # Assuming files are in current directory
   Copy-Item init.lua $env:LOCALAPPDATA\nvim\
   Copy-Item lazy.lua $env:LOCALAPPDATA\nvim\lua\config\
   Copy-Item keymaps.lua $env:LOCALAPPDATA\nvim\lua\config\
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
   ```
   :MasonInstall pyright lua-language-server json-lsp yaml-language-server
   ```

4. Install Treesitter parsers:
   ```
   :TSInstall python lua json yaml markdown
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