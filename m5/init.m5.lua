local vim = vim
vim.g.mapleader = " "

require "aldivim.lazy"
require "aldivim.opts" -- must be below lazy
--+ if !danin
require "aldivim.statusline" -- must be below opts
--+ end
vim.schedule(function()
	require "aldivim.lsp" -- must be below lazy
	require "aldivim.keys"
	--+ if !sergey
	require "aldivim.dap"
	--+ end
end)
