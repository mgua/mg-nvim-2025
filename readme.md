# mgua's Neovim 2025 Setup

A modern multiplatform structured configuration for neovim 
Requires at least neovim 0.11. 


## installation

Please follow specific installation documentation for windows or linux
```
install-guide-linux.md

install-guide-windows.md
```

Linux installation also support tmux integration


## features and configuration

This neovim setup integrates the following components:

- multiplatform clipboard support, across chained sessions: 
You can copy/paste across different chained session on different os.
A OSC52 compliant terminal emulator program is required. 
Windows Terminal works-

- nvim-tree, file manager and file navigation, with symbols

- gitsigns, for git integration supporting merge interactions

- comment, for multiple line comments

- telescope, for list-picking, filename search, filecontent search

- lazygit, for easy git interactions

- treesitter, for syntax check, code-folding, indentation, coloring

- fzf-lua, as an simpler and faster alternative to telescope

- mason, for LSP (Language Server Program, for code 
interpretation semantics, function and documentation lookups 

- markdown-preview, for interactive markdown preview, 
potentially with graph language interpreter/preview support

- hex, for binary data view (to be integrated with sixel preview)

- startify, for home startup windows and recent file/project list

- flash, for fast local search and fast cursor movement

- which-key, to show key mapping configuration and help



## treesitter issues when editing files on network shares from Windows

treesitter functionality may have issues when editing files on non c: drives
The solution we designed is to keep a well designed link set in a dedicated folder, 
on each user home folder or on the main c:/ drive

this folder is a very nice, functional and portable way to manage 
files and project folders across the network or mounted drives, whatever the
protocol (cifs, iscsi, nfs)
this approach works cross systems


```powershell
# Create mount point structure on C: (require admin rights)
mkdir C:\mnt

# Symlink your network shares
mklink /D C:\mnt\share1 \\server\share1
mklink /D C:\mnt\share2 \\fileserver\projects
mklink /D C:\mnt\nas \\192.168.1.100\data

# Now edit files via C:\mnt\* paths in Neovim
```

or, within user homes we create a ~/mnt folder

```powershell
mkdir "$env:USERPROFILE/mnt
mklink /J "$env:USERPROFILE/mnt/lod_d d:/
mklink /J "$env:USERPROFILE/mnt/my_project e:/some/path/myprj/

mklink /D "$env:USERPROFILE/mnt/net_prj_x //file.server.com/path1/path2/x/
```


