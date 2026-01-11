# Neovim Modern Setup - Linux Installation

## Prerequisites Installation

### Ubuntu/Debian
1. Install Neovim:
   ```bash
   # Add repository for latest version
   sudo add-apt-repository ppa:neovim-ppa/unstable
   sudo apt update
   sudo apt install neovim
   ```

2. Install dependencies:
   ```bash
   sudo apt install git nodejs npm python3 python3-pip xclip ripgrep fd-find
   ```

3. Install LazyGit:
   ```bash
   LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
   curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
   tar xf lazygit.tar.gz lazygit
   sudo install lazygit /usr/local/bin
   ```

### Arch Linux
```bash
sudo pacman -S neovim git nodejs npm python python-pip xclip lazygit ripgrep fd
```

### Fedora
```bash
sudo dnf install neovim git nodejs npm python3 python3-pip xclip ripgrep fd-find
# Install LazyGit using the same method as Ubuntu
```

## Nerd Font Installation

1. Create fonts directory:
   ```bash
   mkdir -p ~/.local/share/fonts
   ```

2. Download and install Hack Nerd Font:
   ```bash
   cd ~/.local/share/fonts
   wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
   unzip Hack.zip
   rm Hack.zip
   fc-cache -fv
   ```

## Neovim Configuration Setup

### File Structure
```
~/.config/nvim/
├── init.lua
└── lua/
    └── config/
        ├── lazy.lua
        ├── keymaps.lua
        └── languages.lua
```

### Installation Steps

1. Create neovim config directory:
   ```bash
   mkdir -p ~/.config/nvim/lua/config
   ```

2. Copy configuration files:
   ```bash
   # Assuming files are in current directory
   cd  ~/.config/nvim/
   git clone https://github.com/mgua/mg-nvim-2025.git .
   ```


## Terminal Configuration

### GNOME Terminal
1. Open Preferences
2. Select your profile
3. Under "Text":
   - Check "Custom font"
   - Select "Hack Nerd Font"
   - Set size to 12 (or preferred)
4. Under "Colors":
   - Uncheck "Use colors from system theme"
   - Choose a dark theme
   - Adjust transparency if desired

### Konsole
1. Settings → Configure Konsole
2. Edit current profile
3. Under "Appearance":
   - Font → Select "Hack Nerd Font"
   - Color scheme → Choose a dark theme
   - Adjust background transparency if desired

### Alacritty
Add to `~/.config/alacritty/alacritty.yml`:
```yaml
font:
  normal:
    family: "Hack Nerd Font"
    style: Regular
  bold:
    family: "Hack Nerd Font"
    style: Bold
  italic:
    family: "Hack Nerd Font"
    style: Italic
  bold_italic:
    family: "Hack Nerd Font"
    style: Bold Italic
  size: 12
```


## First Launch Setup

1. Start Neovim:
   ```bash
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
```bash
# Config directory
ls -la ~/.config/nvim

# Data directory
ls -la ~/.local/share/nvim

# Plugin directory
ls -la ~/.local/share/nvim/lazy

# LSP servers
ls -la ~/.local/share/nvim/mason
```

## Updating

1. Update Neovim:
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt upgrade neovim
   
   # Arch
   sudo pacman -Syu neovim
   
   # Fedora
   sudo dnf upgrade neovim
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

## Optional but Recommended

1. Install ripgrep for better grep:
   ```bash
   # Ubuntu/Debian
   sudo apt install ripgrep
   
   # Arch
   sudo pacman -S ripgrep
   
   # Fedora
   sudo dnf install ripgrep
   ```

2. Install fd for better file finding:
   ```bash
   # Ubuntu/Debian
   sudo apt install fd-find
   
   # Arch
   sudo pacman -S fd
   
   # Fedora
   sudo dnf install fd-find
   ```

3. OPTIONAL: Add to your shell configuration (`~/.bashrc` or `~/.zshrc`):
   ```bash
   # Set Neovim as default editor
   export EDITOR=nvim
   export VISUAL=nvim
   
   # Aliases
   alias vim=nvim
   alias vi=nvim
   ```

