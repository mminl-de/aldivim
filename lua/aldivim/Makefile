LUAFILES ?= prep.lua lazy.lua keys.lua opts.lua

julian:
	m4 -DJULIAN $(LUAFILES)| grep -v "\-\- m4:" > init.lua
sergey:
	m4 -DSERGEY $(LUAFILES) | grep -v "\-\- m4:" > init.lua
