# Neovim Modern Setup Installation Guide

## Prerequisites

### Windows
1. Install Neovim:
   ```powershell
   winget install Neovim.Neovim
   # OR
   scoop install neovim
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

4. Install Node.js (for LSP):
   ```powershell
   winget install OpenJS.NodeJS.LTS
   ```

5. Install Python and pip:
   ```powershell
   winget install Python.Python.3.11
   ```

### Linux
1. Install Neovim (Ubuntu/Debian):
   ```bash
   sudo apt install neovim
   ```

2. Install dependencies:
   ```bash
   sudo apt install git nodejs npm python3 python3-pip
   ```

3. Install LazyGit:
   ```bash
   LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
   curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
   tar xf lazygit.tar.gz lazygit
   sudo install lazygit /usr/local/bin
   ```

## Nerd Fonts Installation

### Windows
1. Download Hack Nerd Font:
   - Visit: https://github.com/ryanoasis/nerd-fonts/releases/latest
   - Download `Hack.zip`
2. Extract and Install:
   - Extract the ZIP file
   - Select all `.ttf` files
   - Right-click → Install for all users

### Linux
```bash
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
unzip Hack.zip -d ~/.local/share/fonts/
fc-cache -fv
```

## Neovim Configuration Setup

### File Locations

#### Windows
```
%LOCALAPPDATA%\nvim\
├── init.lua
└── lua\
    └── config\
        ├── lazy.lua
        ├── keymaps.lua
        └── languages.lua
```
In CMD or PowerShell:
```powershell
mkdir %LOCALAPPDATA%\nvim\lua\config
# Copy files to their respective locations:
# - init.lua → %LOCALAPPDATA%\nvim\init.lua
# - lazy.lua → %LOCALAPPDATA%\nvim\lua\config\lazy.lua
# - keymaps.lua → %LOCALAPPDATA%\nvim\lua\config\keymaps.lua
# - languages.lua → %LOCALAPPDATA%\nvim\lua\config\languages.lua
```

#### Linux
```
~/.config/nvim/
├── init.lua
└── lua/
    └── config/
        ├── lazy.lua
        ├── keymaps.lua
        └── languages.lua
```
In terminal:
```bash
mkdir -p ~/.config/nvim/lua/config
# Copy files to their respective locations:
# - init.lua → ~/.config/nvim/init.lua
# - lazy.lua → ~/.config/nvim/lua/config/lazy.lua
# - keymaps.lua → ~/.config/nvim/lua/config/keymaps.lua
# - languages.lua → ~/.config/nvim/lua/config/languages.lua
```

## Terminal Configuration

### Windows Terminal
1. Open Settings (Ctrl+,)
2. Select your profile (Windows PowerShell, Command Prompt, etc.)
3. Under "Appearance" → "Font face", select "Hack Nerd Font" or "Hack Nerd Font Mono"
4. Optional: Set "Font size" to 12 or your preferred size

### Linux Terminal
- **GNOME Terminal**:
  1. Open Preferences
  2. Select your profile
  3. Check "Custom font"
  4. Select "JetBrainsMono Nerd Font"

- **Konsole**:
  1. Settings → Configure Konsole
  2. Edit current profile
  3. Appearance → Font → Select "JetBrainsMono Nerd Font"

## First Launch

1. Start Neovim:
   ```bash
   nvim
   ```

2. The configuration will automatically:
   - Install Lazy.nvim (plugin manager)
   - Install all configured plugins
   - Set up LSP servers via Mason

3. Install LSP servers:
   ```
   :MasonInstall pyright lua-language-server json-lsp yaml-language-server
   ```

## Key Features and Mappings

- File Explorer:
  - `<C-n>` - Toggle file explorer
  - `<leader>e` - Focus file explorer

- Git Integration:
  - `<leader>gg` - Open LazyGit
  - `<leader>hs` - Stage hunk
  - `<leader>hr` - Reset hunk
  - `<leader>hb` - Git blame
  - `]c` and `[c` - Navigate changes

- LSP:
  - `gd` - Go to definition
  - `gr` - Find references
  - `K` - Show hover documentation
  - `<leader>ca` - Code actions
  - `<leader>rn` - Rename

- Clipboard:
  - `<leader>y` - Copy to system clipboard
  - `<leader>p` - Paste from system clipboard

## Tmux Integration

### Basic Tmux Configuration
Create or edit `~/.tmux.conf`:
```bash
# Set true color support
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Reduce escape time for neovim
set-option -sg escape-time 10

# Enable focus events
set-option -g focus-events on

# Set a higher history limit
set-option -g history-limit 50000

# Modern copy mode settings
set-window-option -g mode-keys vi
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

# Smart pane switching with awareness of Vim splits
bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"

# Mouse support
set -g mouse on
```

### Install Tmux Plugin Manager (TPM)
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Add to your `~/.tmux.conf`:
```bash
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-yank'         # Better clipboard integration
set -g @plugin 'tmux-plugins/tmux-resurrect'    # Session save/restore
set -g @plugin 'christoomey/vim-tmux-navigator' # Seamless vim-tmux navigation

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm'
```

After adding plugins, press `prefix` + `I` (capital i) to install them.

### Additional Tmux Tips

1. Session Management:
   - `tmux new -s mysession` - Create new named session
   - `prefix + s` - List sessions
   - `prefix + d` - Detach from session
   - `tmux attach -t mysession` - Attach to named session

2. Copy/Paste in Tmux:
   - Enter copy mode: `prefix + [` 
   - Start selection: `v` (if using vi mode)
   - Copy selection: `y`
   - Paste: `prefix + ]`

3. Navigation:
   - Between panes: `Ctrl + h/j/k/l` (with vim-tmux-navigator)
   - Between windows: `prefix + p/n` (previous/next)
   - Resize panes: `prefix + H/J/K/L`

### Troubleshooting Tmux Integration

1. Colors look wrong in Tmux:
   - Verify your terminal supports true color
   - Check that both tmux and Neovim color settings are correct
   - Try running: `echo $TERM` outside and inside tmux to verify terminal type

2. Clipboard not working:
   - Ensure tmux-yank is installed
   - Check if xclip/xsel is installed on Linux
   - Verify OSC52 settings in your terminal

3. Slow escape key in Neovim:
   - Verify `escape-time` is set to 10 or lower in tmux.conf
   - Check `timeoutlen` and `ttimeoutlen` settings in Neovim

## Troubleshooting

1. If you see boxes instead of icons:
   - Verify Nerd Font installation
   - Confirm terminal is using the Nerd Font
   - Restart your terminal

2. If clipboard isn't working in remote sessions:
   - Confirm your terminal supports OSC52
   - Check that the remote server can connect to your local machine

3. If LSP isn't working:
   - Run `:Mason` and check if servers are installed
   - Run `:LspInfo` to check server status
   - Verify Node.js installation: `node --version`