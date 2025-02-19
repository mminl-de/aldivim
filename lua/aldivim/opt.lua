local vim = vim
local o = vim.opt

-- line numbers
o.number = true
o.relativenumber = true -- disable this line to have "normal" line numbers

-- tabs
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

-- wrap
o.wrap = true
o.linebreak = true

-- colorscheme
vim.cmd.colorscheme "catppuccin-mocha"

-- backups
o.swapfile = false
o.backup = false

-- scrolloff
o.scrolloff = 29

-- rulers
o.colorcolumn = { 80, 90 }

-- For some reason, nvim autoformats Zig code out of the box.
-- This disables it.
vim.g.zig_fmt_autosave = 0
