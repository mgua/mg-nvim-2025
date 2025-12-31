-- allows copy from nvim to clipboard across terminal emulators 
-- see https://github.com/ojroques/nvim-osc52
-- this is supported by windows terminal (and others)
-- this may be useless because from neovim 0.10 this has been 
-- integrated into neovim. check :h clipboard-osc52
--
-- main use of this clipboard functionality is to copy from 
-- a remote neovim terminal session to local os clipboard 
-- (not the other way around)
--

return {
	'ojroques/nvim-osc52' 
	}


