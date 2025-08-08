-- m4 changequote(<<<, >>>)
local vim = vim
local telescope = require "telescope"
local builtin = require "telescope.builtin"
-- m4 ifdef(<<<SERGEY>>>, <<<
-- m4 >>>, <<<
local dap = require "dap"
-- m4 >>>)

require "which-key".add {
	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- neovim config
	{ "<leader>n", group = "neovim" },
	{ "<leader>nk", function() vim.cmd.edit "~/.config/nvim/lua/aldivim/keys.lua" end, desc = "Open nvim's key config" },
	{ "<leader>nl", function() vim.cmd.edit "~/.config/nvim/lua/aldivim/lazy.lua" end, desc = "Open nvim's plugin config" },
	{ "<leader>no", function() vim.cmd.edit "~/.config/nvim/lua/aldivim/opts.lua" end, desc = "Open nvim's core config" },

	-- aldivim config
	{ "<leader>nm", group = "aldivim" },
	{ "<leader>nmk", function() vim.cmd.edit "~/.config/nvim/m4/keys.m4.lua" end, desc = "Open aldivim's key config" },
	{ "<leader>nml", function() vim.cmd.edit "~/.config/nvim/m4/lazy.m4.lua" end, desc = "Open aldivim's plugin config" },
	{ "<leader>nmo", function() vim.cmd.edit "~/.config/nvim/m4/opts.m4.lua" end, desc = "Open aldivim's core config" },
	-- m4 >>>)

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- other configs
	{ "<leader>,", group = "config" },
	{ "<leader>,f", function() vim.cmd.edit "~/.config/fish/config.fish" end, desc = "Open shell config" },
	{ "<leader>,s", function() vim.cmd.edit "~/.config/sway/config" end, desc = "Open window manager config" },

	-- uni
	{ "<leader>u", group = "uni" },
	{ "<leader>um", function() vim.cmd.edit "~/uni/vimwiki/main.wiki" end, desc = "Open uni wiki page" },
	{ "<leader>uo", function() vim.cmd.Telescope("find_files", "cwd=~/uni/vimwiki") end, desc = "Find uni pages" },
	-- m4 >>>)

	-- editing
	{ "<leader><leader>", vim.cmd.write, desc = "Save file" },
	{ "<leader>k", function() vim.wo.wrap = not vim.wo.wrap end, desc = "Toggle wrap" },
	{ "<leader>q", ":q!<cr>", desc = "Quit without saving" },
	{ "<leader>t", function() vim.api.nvim_feedkeys(":tag ", "n", false) end,  desc = "Go to tag" },
	{ "<leader>z", vim.cmd.wq, desc = "Save and quit" },

	-- buffers
	{ "<leader>x", vim.cmd.bdelete, desc = "Close buffer" },
	{ "<leader><tab>", vim.cmd.bnext, desc = "Go to next buffer" },
	{ "<leader><s-tab>", vim.cmd.bprev, desc = "Go to previous buffer" },

	-- split panes
	{ "<leader>j", vim.cmd.split, desc = "Split pane down" },
	{ "<leader>l", vim.cmd.vsplit, desc = "Split pane to the right" },

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- resize panes
	{ "<m-<>", function() vim.cmd "vertical resize -8" end, desc = "Shrink pane vertically" },
	{ "<m-s-<>", function() vim.cmd "vertical resize +8" end, desc = "Grow pane vertically" },
	{ "<m-->", function() vim.cmd "horizontal resize -4" end, desc = "Shrink pane horizontally" },
	{ "<m-+>", function() vim.cmd "horizontal resize +4" end, desc = "Grow pane horizontally" },
	-- m4 >>>)

	-- telescope
	{ "<leader>.", builtin.oldfiles, desc = "View recent files" },
	{ "<leader>b", builtin.buffers, desc = "View open buffers" },
	{ "<leader>d", function()
		builtin.diagnostics { bufnr = 0, line_width = "full" }
	end, desc = "View LSP diagnostics" },
	{ "<leader>e", telescope.extensions.file_browser.file_browser, desc = "Browse files" },
	{ "<leader>f", builtin.find_files, desc = "Find files in this directory" },
	-- m4 ifdef(<<<SERGEY>>>, <<<
	{ "<leader>c", function()
		builtin.colorscheme { ignore_builtins = true }
	end, desc = "Change colorscheme" },
	-- m4 >>>, <<<
	{ "<leader>C", function()
		builtin.colorscheme { ignore_builtins = true }
	end, desc = "Change colorscheme" },
	-- m4 >>>)

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- vimwiki
	{ "<leader>a", function() vim.cmd.edit "~/stuff/vimwiki/Aufgaben.wiki" end, desc = "Open tasks wiki page" },
	{ "<leader>m", function() vim.cmd.edit "~/stuff/vimwiki/main.wiki" end, desc = "Open main wiki page" },
	{ "<leader>o", function() vim.cmd.Telescope("find_files", "cwd=~/stuff/vimwiki") end, desc = "Find wiki pages" },
	{ "<leader>p", function() vim.cmd.edit "~/stuff/vimwiki/Programmieren.wiki" end, desc = "Open programming wiki page" },
	{ "<leader>w", function() vim.cmd.Telescope("find_files", "cwd=~/stuff/writing") end, desc = "Find writing wiki pages" },
	{ "<leader>v", group = "vimwiki" },
	{ "<leader>vb", vim.cmd.VimwikiBacklinks, desc = "Show this wiki page's backlinks" },
	{ "<leader>vd", vim.cmd.VimwikiDeleteFile, desc = "Delete this wiki page" },
	{ "<leader>vr", vim.cmd.VimwikiRenameFile, desc = "Rename this wiki page" },
	-- m4 >>>)

	-- lsp
	{ "<leader>r", function()
		vim.diagnostic.open_float(nil, { focus = false })
	end, desc = "View the full LSP message on this line" },

	-- etc
	{ "<esc>", vim.cmd.nohlsearch, desc = "Remove search highlights" },
	-- m4 ifdef(<<<SERGEY>>>, <<<
	{ "<leader>g", function() vim.cmd.Goyo() vim.g.goyo_on = not vim.g.goyo_on end, desc = "Toggle zen mode" },
	{ "<leader>h", function() vim.cmd.ColorizerToggle() vim.g.colorizer_on = not vim.g.colorizer_on end, desc = "Toggle hex colorizer" },
	-- m4 >>>, <<<
	{ "<leader>i", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, desc = "Toggle inlay hints" },
	-- m4 >>>)
	{ "<m-space>", function()
		local line = vim.api.nvim_get_current_line()
		local subject, doc, page = line:match "(%w+)%s+(%d+):(%d+)"

		if not subject then
			vim.notify("No bible verse found", vim.log.levels.ERROR)
			return
		end

		vim.system {
			"zathura",
			os.getenv "HOME" .. "/uni/" .. subject .. "/" .. doc .. ".pdf",
			"--page=" .. page
		}
	end, desc = "Open the PDF of the referenced slide" },

	-- m4 ifdef(<<<SERGEY>>>, <<<
	{
		mode = "i",

		{ "<m-backspace>", "<c-w>", desc = "Delete last word" },

		-- vimwiki
		{ "<c-8>", "[[]]<left><left>", desc = "Insert vimwiki link" },
		{ "<m-0>", "==<left>", desc = "Insert vimwiki heading" },
	},
	-- m4 >>>)

	{
		mode = { "n", "i" },

		-- focus panes
		{ "<m-h>", function() vim.cmd.wincmd "h" end, desc = "Focus pane to the left" },
		{ "<m-j>", function() vim.cmd.wincmd "j" end, desc = "Focus pane below" },
		{ "<m-k>", function() vim.cmd.wincmd "k" end, desc = "Focus pane above" },
		{ "<m-l>", function() vim.cmd.wincmd "l" end, desc = "Focus pane to the right" },

		-- lsp
		{ "<f2>", vim.lsp.buf.rename, desc = "Rename symbol under cursor" },
	},

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- m4 >>>, <<<
	-- DAP
	{
		{ "<leader>Dr", dap.run, desc = "DAP Run <F4>" },
		{ "<leader>Ds", dap.step_over, desc = "DAP Step Over <F5>" },
		{ "<leader>Di", dap.step_into, desc = "DAP Step Into <F6>" },
		{ "<leader>Dc", dap.continue, desc = "DAP Continue <F7>" },
		{ "<leader>Do", dap.step_out, desc = "DAP Step Out <F8>" },
		{ "<leader>Db", dap.toggle_breakpoint, desc = "DAP Toggle Breakpoint" },
		{ "<leader>Bb", dap.toggle_breakpoint, desc = "DAP Toggle Breakpoint" },
		{ "<leader>Dt", dap.terminate, desc = "DAP Terminate" },
		{ "<f4>", dap.run, desc = "DAP Run" },
		{ "<f5>", dap.step_over, desc = "DAP step Over" },
		{ "<f6>", dap.step_into, desc = "DAP Step Into" },
		{ "<f7>", dap.continue, desc = "DAP Continue" },
		{ "<f8>", dap.step_out, desc = "DAP Step Out" },
		{ "<f1>", dap.run_last, desc = "DAP Run Last" },
	},
	-- m4 >>>)
}
