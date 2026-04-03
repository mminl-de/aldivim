vim.g.mapleader = " "

require "aldivim.lazy"
require "aldivim.opts" -- should be below lazy
require "aldivim.lsp" -- should be below lazy
require "aldivim.keys"
--+ if !sergey
require "aldivim.dap"
--+ end
