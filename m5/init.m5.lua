local vim = vim
vim.g.mapleader = " "

require "aldivim.lazy"
require "aldivim.opts" -- should be below lazy
vim.schedule(function()
	require "aldivim.lsp" -- should be below lazy
	require "aldivim.keys"
	--+ if !sergey
	require "aldivim.dap"
	--+ end
end)
