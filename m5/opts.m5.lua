local vim = vim
local opt = vim.opt
local g = vim.g

-- appearance
opt.title = true
opt.number = true
opt.relativenumber = true

-- colorscheme
--+ if julian
vim.cmd.colorscheme "monokai-pro-spectrum"
--+ else
vim.cmd.colorscheme "catppuccin-mocha"
--+ end

--+ if julian
-- command line
opt.wildoptions = { "fuzzy" }
--+ end

-- cursor line
opt.cursorline = true

-- buffers
opt.splitright = true
opt.splitbelow = true

-- clipboard
opt.clipboard = "unnamedplus"

-- indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
--+ if danin
opt.expandtab = true
--+ else
opt.expandtab = false
--+ end
opt.smartindent = true

--+ if sergey
-- visualize tabs and spaces
opt.list = true
opt.listchars = {
	tab = "│ ",
	trail = "·",
	extends = "»",
	precedes = "«",
	nbsp = "␣"
}
--+ end

-- wrap
opt.wrap = false
opt.linebreak = true
opt.breakindent = true

-- backups
opt.swapfile = false
opt.backup = false

-- scrolloff
--+ if sergey
opt.scrolloff = 32
--+ else
opt.scrolloff = 5
--+ end

-- column rulers
opt.colorcolumn = { 80, 90 }

-- languages
--+ if sergey
opt.makeprg = "zig build"
--+ end
g.zig_recommended_style = 0 -- disable audacious tab logic overrides by Zig
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

--+ if !sergey
-- floating windows
opt.winborder = "rounded"
--+ end
