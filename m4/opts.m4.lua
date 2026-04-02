-- m4 changequote(<<<, >>>)
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
-- m4 ifdef(<<<DANIN>>>, <<<
o.expandtab = true
-- m4 >>>, <<<
o.expandtab = false
-- m4 >>>)

-- m4 ifdef(<<<SERGEY>>>, <<<
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
-- m4 >>>)

-- wrap
o.wrap = false
o.linebreak = true

-- colorscheme
-- m4 ifdef(<<<JULIAN>>>, <<<
vim.cmd.colorscheme "monokai-pro-spectrum"
-- m4 >>>)
-- m4 ifdef(<<<SERGEY>>>, <<<
vim.cmd.colorscheme "catppuccin-mocha"
-- m4 >>>)
-- m4 ifdef(<<<DANIN>>>, <<<
vim.cmd.colorscheme "catppuccin-mocha"
-- m4 >>>)

-- m4 ifdef(<<<SERGEY>>>, <<<
-- terminal colors
o.termguicolors = true
-- m4 >>>)

-- backups
o.swapfile = false
o.backup = false

-- scrolloff
-- m4 ifdef(<<<SERGEY>>>, <<<
o.scrolloff = 29
-- m4 >>>, <<<
o.scrolloff = 5
-- m4 >>>)

-- rulers
o.colorcolumn = { 80, 90 }

-- zig?
vim.g.zig_fmt_autosave = 0      -- disable automatic zig formatting
vim.g.zig_recommended_style = 0 -- disable audacious tab logic overrides by Zig

-- custom variables for lualine modules
-- m4 ifdef(<<<JULIAN>>>, <<<
vim.g.colorizer_on = true
-- m4 >>>, <<<
vim.g.colorizer_on = false
-- m4 >>>)
-- m4 ifdef(<<<SERGEY>>>, <<<
vim.g.inlay_hints_on = false
-- m4 >>>)

-- floating windows
o.winborder = "rounded"
