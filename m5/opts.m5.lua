local vim = vim
local opt = vim.opt
local g = vim.g

-- appearance
opt.title = true
opt.number = true
opt.relativenumber = true
--+ if sergey
opt.laststatus = 3 -- only one status line per session
opt.showmode = false -- dont print "-- INSERT --"
--+ end
--+ if !danin
vim.o.statusline = table.concat({
	" %<%f %h%w%m%r %{%",
	"v:lua.require('vim._core.util').term_exitcode() %}%=%{%",
	"luaeval('(package.loaded[''vim.ui''] and",
		"vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1) and",
		"vim.ui.progress_status()) or",
		"'''' ')%}%{%",
	"&showcmdloc == 'statusline' ? '%-10.S ' : '' %}%{%",
	"exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}%{%",
	"&busy > 0 ? '◐ ' : '' %}%{%",
	"luaeval('(package.loaded[''vim.diagnostic''] and",
		"next(vim.diagnostic.count()) and",
		"vim.diagnostic.status() .. '' '') or",
		"'''' ') %}%{%",
	"'%-14.(%l,%c%V%) %y %P' %} "
}, " ")
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

-- disable mouse
opt.mouse = {}
--+ end

-- wrap
opt.wrap = false
opt.linebreak = true

-- colorscheme
--+ if julian
vim.cmd.colorscheme "monokai-pro-spectrum"
--+ else
vim.cmd.colorscheme "catppuccin-mocha"
--+ end

-- backups
opt.swapfile = false
opt.backup = false

-- scrolloff
--+ if sergey
opt.scrolloff = 29
--+ else
opt.scrolloff = 5
--+ end

-- rulers
opt.colorcolumn = { 80, 90 }

-- languages
g.zig_recommended_style = 0 -- disable audacious tab logic overrides by Zig
--+ if sergey
opt.makeprg = "zig build"
--+ end
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

-- floating windows
opt.winborder = "rounded"
