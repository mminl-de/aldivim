local vim = vim
local o = vim.opt

-- window title
o.title = true

-- line numbers
o.number = true
o.relativenumber = true

-- cursor line
o.cursorline = true

-- buffers
o.splitright = true
o.splitbelow = true

-- clipboard
o.clipboard = "unnamedplus"

-- indentation
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
--+ if danin
o.expandtab = true
--+ else
o.expandtab = false
--+ end

--+ if sergey
-- visualize tabs and spaces
o.list = true
o.listchars = {
	tab = "│ ",
	trail = "·",
	extends = "»",
	precedes = "«",
	nbsp = "␣"
}

-- disable mouse
o.mouse = {}
--+ end

-- wrap
o.wrap = false
o.linebreak = true

-- colorscheme
--+ if julian
vim.cmd.colorscheme "monokai-pro-spectrum"
--+ else
vim.cmd.colorscheme "catppuccin-mocha"
--+ end

-- backups
o.swapfile = false
o.backup = false

-- scrolloff
--+ if sergey
o.scrolloff = 29
--+ else
o.scrolloff = 5
--+ end

-- rulers
o.colorcolumn = { 80, 90 }

-- zig?
vim.g.zig_recommended_style = 0 -- disable audacious tab logic overrides by Zig

-- floating windows
o.winborder = "rounded"
