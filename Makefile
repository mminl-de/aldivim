d danin:
	mkdir -p lua/aldivim
	m5 -p:--+ -d:danin -o:lua/aldivim/init.lua m5/init.m5.lua
	m5 -p:--+ -d:danin -o:lua/aldivim/keys.lua m5/keys.m5.lua
	m5 -p:--+ -d:danin -o:lua/aldivim/lazy.lua m5/lazy.m5.lua
	m5 -p:--+ -d:danin -o:lua/aldivim/opts.lua m5/opts.m5.lua
	m5 -p:--+ -d:danin -o:lua/aldivim/lsp.lua m5/lsp.m5.lua
	m5 -p:--+ -d:danin -o:lua/aldivim/dap.lua m5/dap.m5.lua

j julian:
	mkdir -p lua/aldivim
	m5 -p:--+ -d:julian -o:lua/aldivim/init.lua m5/init.m5.lua
	m5 -p:--+ -d:julian -o:lua/aldivim/keys.lua m5/keys.m5.lua
	m5 -p:--+ -d:julian -o:lua/aldivim/lazy.lua m5/lazy.m5.lua
	m5 -p:--+ -d:julian -o:lua/aldivim/opts.lua m5/opts.m5.lua
	m5 -p:--+ -d:julian -o:lua/aldivim/lsp.lua m5/lsp.m5.lua
	m5 -p:--+ -d:julian -o:lua/aldivim/dap.lua m5/dap.m5.lua

s sergey:
	mkdir -p lua/aldivim
	m5 -p:--+ -d:sergey -o:lua/aldivim/init.lua m5/init.m5.lua
	m5 -p:--+ -d:sergey -o:lua/aldivim/keys.lua m5/keys.m5.lua
	m5 -p:--+ -d:sergey -o:lua/aldivim/lazy.lua m5/lazy.m5.lua
	m5 -p:--+ -d:sergey -o:lua/aldivim/opts.lua m5/opts.m5.lua
	m5 -p:--+ -d:sergey -o:lua/aldivim/lsp.lua m5/lsp.m5.lua
	rm -f lua/aldivim/dap.lua

root-sergey:
	make sergey
	sudo mkdir /root/.config/nvim
	sudo cp -riv lua /root/.config/nvim/lua
	sudo cp -riv init.lua /root/.config/nvim/init.lua

# TODO deps installieren
# tree-sitter-cli
# m5
# LSP für einzelne Personen
