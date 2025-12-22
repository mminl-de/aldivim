-- m4 changequote(<<<, >>>)
vim.g.mapleader = " "

require "aldivim.lazy"
require "aldivim.opts" -- should be below lazy
require "aldivim.lsp" -- should be below lazy
require "aldivim.keys"
-- m4 ifdef(<<<SERGEY>>>, <<<>>>, <<<
require "aldivim.dap"
-- m4 >>>)
