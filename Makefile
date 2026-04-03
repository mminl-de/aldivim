d danin:
	mkdir -p lua/aldivim
	m5 -p:--+ -d:danin m5/init.m5.lua -o:lua/aldivim/init.lua
	m5 -p:--+ -d:danin m5/keys.m5.lua -o:lua/aldivim/keys.lua
	m5 -p:--+ -d:danin m5/lazy.m5.lua -o:lua/aldivim/lazy.lua
	m5 -p:--+ -d:danin m5/opts.m5.lua -o:lua/aldivim/opts.lua
	m5 -p:--+ -d:danin m5/lsp.m5.lua -o:lua/aldivim/lsp.lua
	m5 -p:--+ -d:danin m5/dap.m5.lua -o:lua/aldivim/dap.lua

j julian:
	mkdir -p lua/aldivim
	m5 -p:--+ -d:julian m5/init.m5.lua -o:lua/aldivim/init.lua
	m5 -p:--+ -d:julian m5/keys.m5.lua -o:lua/aldivim/keys.lua
	m5 -p:--+ -d:julian m5/lazy.m5.lua -o:lua/aldivim/lazy.lua
	m5 -p:--+ -d:julian m5/opts.m5.lua -o:lua/aldivim/opts.lua
	m5 -p:--+ -d:julian m5/lsp.m5.lua -o:lua/aldivim/lsp.lua
	m5 -p:--+ -d:julian m5/dap.m5.lua -o:lua/aldivim/dap.lua

s sergey:
	mkdir -p lua/aldivim
	m5 -p:--+ -d:sergey m5/init.m5.lua -o:lua/aldivim/init.lua
	m5 -p:--+ -d:sergey m5/keys.m5.lua -o:lua/aldivim/keys.lua
	m5 -p:--+ -d:sergey m5/lazy.m5.lua -o:lua/aldivim/lazy.lua
	m5 -p:--+ -d:sergey m5/opts.m5.lua -o:lua/aldivim/opts.lua
	m5 -p:--+ -d:sergey m5/lsp.m5.lua -o:lua/aldivim/lsp.lua
