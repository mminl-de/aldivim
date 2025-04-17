julian:
	m4 -DJULIAN m4/keys.m4.lua | grep -v -- "-- m4" > lua/aldivim/keys.lua
	m4 -DJULIAN m4/lazy.m4.lua | grep -v -- "-- m4" > lua/aldivim/lazy.lua
	m4 -DJULIAN m4/opts.m4.lua | grep -v -- "-- m4" > lua/aldivim/opts.lua

sergey:
	m4 -DSERGEY m4/keys.m4.lua | grep -v -- "-- m4" > lua/aldivim/keys.lua
	m4 -DSERGEY m4/lazy.m4.lua | grep -v -- "-- m4" > lua/aldivim/lazy.lua
	m4 -DSERGEY m4/opts.m4.lua | grep -v -- "-- m4" > lua/aldivim/opts.lua
