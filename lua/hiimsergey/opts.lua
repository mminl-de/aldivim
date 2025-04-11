local vim = vim
local o = vim.opt

-- line numbers
o.number = true
o.relativenumber = true

-- tabs
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

-- wrap
o.wrap = true
o.linebreak = true

-- colorscheme
vim.cmd.colorscheme "catppuccin-mocha"

-- terminal colors
o.termguicolors = true

-- backups
o.swapfile = false
o.backup = false

-- scrolloff
o.scrolloff = 29

-- rulers
o.colorcolumn = { 80, 90 }

-- for some reason, nvim autoformats zig code out of the box.
-- the worst thing is that it also does it in a bad manner.
-- this line disables it.
vim.g.zig_fmt_autosave = 0

-- custom variables for lualine modules
vim.g.colorizer_on = false
vim.g.goyo_on = false
