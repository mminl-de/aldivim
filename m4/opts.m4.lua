-- m4 changequote(<<<, >>>)
local vim = vim
local o = vim.opt

-- line numbers
o.number = true
o.relativenumber = true

-- m4 ifdef(<<<JULIAN>>>, <<<
o.clipboard = "unnamedplus"
-- m4 >>>)

-- tabs
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
-- m4 ifdef(<<<SERGEY>>>, <<<
o.expandtab = true
-- m4 >>>, <<<
o.expandtab = false
-- m4 >>>)

-- wrap
o.wrap = true
o.linebreak = true

-- colorscheme
-- m4 ifdef(<<<JULIAN>>>, <<<
vim.cmd.colorscheme "gruvbox-material"
-- m4 >>>, <<<
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

-- for some reason, nvim autoformats zig code out of the box.
-- the worst thing is that it also does it in a bad manner.
-- this line disables it.
vim.g.zig_fmt_autosave = 0

-- custom variables for lualine modules
-- m4 ifdef(<<<JULIAN>>>, <<<
vim.g.colorizer_on = true
-- m4 >>>, <<<
vim.g.colorizer_on = false
-- m4 >>>)
vim.g.goyo_on = false
