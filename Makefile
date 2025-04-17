mrminede:
	m4 -DMRMINEDE lua/aldivim/keys.m4.lua | grep -v -- "-- m4" > lua/aldivim/keys.lua
	m4 -DMRMINEDE lua/aldivim/lazy.m4.lua | grep -v -- "-- m4" > lua/aldivim/lazy.lua
	m4 -DMRMINEDE lua/aldivim/opts.m4.lua | grep -v -- "-- m4" > lua/aldivim/opts.lua

hiimsergey:
	m4 -DHIIMSERGEY lua/aldivim/keys.m4.lua | grep -v -- "-- m4" > lua/aldivim/keys.lua
	m4 -DHIIMSERGEY lua/aldivim/lazy.m4.lua | grep -v -- "-- m4" > lua/aldivim/lazy.lua
	m4 -DHIIMSERGEY lua/aldivim/opts.m4.lua | grep -v -- "-- m4" > lua/aldivim/opts.lua
