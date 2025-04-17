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

-- m4 ifdef([HIIMSERGEY], [
-- terminal colors
o.termguicolors = true
-- m4 ])

-- backups
o.swapfile = false
o.backup = false

-- m4 ifdef([HIIMSERGEY], [
-- scrolloff
o.scrolloff = 29
-- m4 ])

-- rulers
o.colorcolumn = { 80, 90 }

-- for some reason, nvim autoformats zig code out of the box.
-- the worst thing is that it also does it in a bad manner.
-- this line disables it.
vim.g.zig_fmt_autosave = 0

-- custom variables for lualine modules
-- m4 ifdef([HIIMSERGEY], [
vim.g.colorizer_on = false
-- m4 ])
vim.g.goyo_on = false
