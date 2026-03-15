-- m4 changequote(<<<, >>>)
local vim = vim
local telescope = require "telescope"
local builtin = require "telescope.builtin"
-- m4 ifdef(<<<SERGEY>>>, <<<>>>, <<<
local dap = require "dap"
-- m4 >>>)

-- m4 ifdef(<<<DANIN>>>, <<<>>>, <<<
-- paste selected text into the search-n-replace Ex command
---@param prefill boolean insert text into "replace field"
local function replace_from_selection(prefill)
	-- TODO DEBUG
	vim.api.nvim_feedkeys("", "x", false)

	local buf = 0
	local s = vim.api.nvim_buf_get_mark(buf, "<")
	local e = vim.api.nvim_buf_get_mark(buf, ">")

	local input = table.concat(
		vim.api.nvim_buf_get_text(buf, s[1] - 1, s[2], e[1] - 1, e[2] + 1, {}),
		"\n"
	)
		:gsub("\\", "\\\\")
		:gsub("/", "\\/")
		:gsub("%*", "\\*")
		:gsub("%[", "\\[")
		:gsub("%]", "\\]")

	local pat = ":%s/" .. input .. "/"
	if prefill then pat = pat .. input end
	pat = pat .. "/g<left><left>"

	local keys = vim.api.nvim_replace_termcodes(pat, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end
-- m4 >>>)

require "which-key".add {
	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- aldivim config
	{ "<leader>n", group = "aldivim" },
	{ "<leader>nk", ":e ~/.config/nvim/m4/keys.m4.lua<cr>", desc = "Open aldivim's key config" },
	{ "<leader>nl", ":e ~/.config/nvim/m4/lsp.m4.lua<cr>", desc = "Open aldivim's core config" },
	{ "<leader>no", ":e ~/.config/nvim/m4/opts.m4.lua<cr>", desc = "Open aldivim's core config" },
	{ "<leader>np", ":e ~/.config/nvim/m4/lazy.m4.lua<cr>", desc = "Open aldivim's plugin config" },

	-- other configs
	{ "<leader>,", group = "config" },
	{ "<leader>,f", ":e ~/.config/fish/config.fish<cr>", desc = "Open shell config" },
	{ "<leader>,s", ":e ~/.config/sway/config<cr>", desc = "Open window manager config" },

	-- uni
	{ "<leader>u", group = "uni" },
	{ "<leader>um", ":e ~/uni/vimwiki/main.wiki<cr>", desc = "Open uni wiki page" },
	{ "<leader>uo",
		function()
			builtin.find_files { cwd = "~/uni/vimwiki" }
		end, desc = "Find uni pages" },
	-- m4 >>>)

	-- editing
	{ "<leader><leader>", vim.cmd.write, desc = "Save file" },
	{ "<leader>g", ":%bd|e#<cr>", desc = "Close all other buffers" },
	{ "<leader>s", function() vim.wo.wrap = not vim.wo.wrap end, desc = "Toggle wrap" },
	{ "<leader>q", ":q!<cr>", desc = "Quit without saving" },
	{ "<leader>z", ":wq<cr>", desc = "Save and quit" },

	-- split panes
	{ "<leader>h", ":vs +wincmd\\ h<cr>", desc = "Split pane left" },
	{ "<leader>j", ":sp<cr>", desc = "Split pane down" },
	{ "<leader>k", ":sp +wincmd\\ k<cr>", desc = "Split pane up" },
	{ "<leader>l", ":vs<cr>", desc = "Split pane right" },

	-- terminal
	{ "<leader>t", ":te<cr>", desc = "Open terminal" },
	-- m4 >>>)

	-- telescope
	{ "<leader>.", builtin.oldfiles, desc = "View recent files" },
	{ "<leader>b", builtin.buffers, desc = "View open buffers" },
	{ "<leader>d",
		function()
			builtin.diagnostics { bufnr = 0, line_width = "full" }
		end, desc = "View LSP diagnostics" },
	{ "<leader>e", telescope.extensions.file_browser.file_browser, desc = "Browse files" },
	{ "<leader>f", builtin.find_files, desc = "Find files in this directory" },
	-- m4 ifdef(<<<SERGEY>>>, <<<
	{ "<leader>c",
		function()
			builtin.colorscheme { ignore_builtins = true }
		end, desc = "Change colorscheme" },
	-- m4 >>>, <<<
	{ "<leader>C",
		function()
			builtin.colorscheme { ignore_builtins = true }
		end, desc = "Change colorscheme" },
	-- m4 >>>)

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- vimwiki
	{ "<leader>a", ":e ~/stuff/vimwiki/Aufgaben.wiki<cr>", desc = "Open tasks wiki page" },
	{ "<leader>m", ":e ~/stuff/vimwiki/main.wiki<cr>", desc = "Open main wiki page" },
	{ "<leader>o",
		function()
			builtin.find_files { cwd = "~/stuff/vimwiki" }
		end, desc = "Find wiki pages" },
	{ "<leader>p", ":e ~/stuff/vimwiki/Programmieren.wiki<cr>", desc = "Open programming wiki page" },
	{ "<leader>wo",
		function()
			builtin.find_files { cwd = "~/stuff/writing" }
		end, desc = "Find writing wiki pages" },
	{ "<leader>v", group = "vimwiki" },
	{ "<leader>vb", ":e VimwikiBacklinks<cr>", desc = "Show this wiki page's backlinks" },
	{ "<leader>vd", ":e VimwikiDeleteFile<cr>", desc = "Delete this wiki page" },
	{ "<leader>vr", ":e VimwikiRenameFile<cr>", desc = "Rename this wiki page" },
	-- m4 >>>)

	-- lsp
	{ "<leader>r",
		function()
			vim.diagnostic.open_float(nil, { focus = false })
		end, desc = "View full LSP message" },

	-- etc
	{ "<esc>", ":noh<cr>", desc = "Remove search highlights" },
	{ "<leader>i",
		function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			vim.g.inlay_hints_on = not vim.g.inlay_hints_on
		end, desc = "Toggle inlay hints" },
	{ "<leader>x",
		function()
			-- this implementation doesnt close the window the buffer was on,
			-- instead replacing it with another
			-- ":bp|bd#" didnt work, cause it couldnt close the last buffer
			local bufnr = vim.api.nvim_win_get_buf(0)
			vim.cmd.bprev()
			vim.cmd.bdelete(bufnr)
		end, desc = "Delete buffer" },
	{ "<leader>y",
		function()
			vim.cmd.ColorizerToggle()
			vim.g.colorizer_on = not vim.g.colorizer_on
		end, desc = "Toggle hex colorizer" },
	{ "<m-space>",
		-- TODO CONSIDER REMOVE
		function()
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
		end, desc = "Open PDF of referenced slide" },

	-- m4 ifdef(<<<SERGEY>>>, <<<
	{
		mode = "i",

		-- insert-mode shell behavior
		{ "<c-z>", "<esc>ui", desc = "Undo a change inline" },
		{ "<m-backspace>", "<c-w>", desc = "Delete last word" },

		-- vimwiki
		{ "<c-8>", "[[]]<left><left>", desc = "Insert vimwiki link" },
		{ "<m-0>", "==<left>", desc = "Insert vimwiki heading" },
	},
	-- m4 >>>)

	{
		mode = { "n", "i" },

		-- lsp
		{ "<f2>", vim.lsp.buf.rename, desc = "Rename symbol under cursor" },
	},

	-- m4 ifdef(<<<DANIN>>>, <<<>>>, <<<
	{
		mode = "x", -- all visual modes

		{ ">", ">gv", desc = "Indent block and keep selection" },
		{ "<", "<gv", desc = "Deindent block and keep selection" },
		{ "<leader>r",
			function()
				replace_from_selection(false)
			end, desc = "Replace selected text" },
		{ "<leader>R",
			function()
				replace_from_selection(true)
			end, desc = "Replace selected text (with suggestion)" }
	},
	-- m4 >>>)

	{
		mode = { "n", "i", "t" },
		-- NOTE here, vim.cmd must be used or else the Ex strings get passed
		-- to the terminal directly

		-- focus panes
		{ "<m-h>", function() vim.cmd.wincmd "h" end, desc = "Focus pane left" },
		{ "<m-j>", function() vim.cmd.wincmd "j" end, desc = "Focus pane down" },
		{ "<m-k>", function() vim.cmd.wincmd "k" end, desc = "Focus pane up" },
		{ "<m-l>", function() vim.cmd.wincmd "l" end, desc = "Focus pane right" },

		-- resize panes
		{ "<m-<>", function() vim.cmd "vert resize -8" end, desc = "Shrink pane vertically" },
		{ "<m-s-<>", function() vim.cmd "vert resize +8" end, desc = "Grow pane vertically" },
		{ "<m-->", function() vim.cmd "hor resize -4" end, desc = "Shrink pane horizontally" },
		{ "<m-+>", function() vim.cmd "hor resize +4" end, desc = "Grow pane horizontally" }
	},

	-- m4 ifdef(<<<SERGEY>>>, <<<>>>, <<<
	-- DAP
	{
		{ "<leader>Dr", dap.run, desc = "DAP run <F4>" },
		{ "<leader>Ds", dap.step_over, desc = "DAP Step over <F5>" },
		{ "<leader>Di", dap.step_into, desc = "DAP Step into <F6>" },
		{ "<leader>Dc", dap.continue, desc = "DAP Continue <F7>" },
		{ "<leader>Do", dap.step_out, desc = "DAP Step out <F8>" },
		{ "<leader>Db", dap.toggle_breakpoint, desc = "DAP Toggle breakpoint" },
		{ "<leader>Bb", dap.toggle_breakpoint, desc = "DAP Toggle breakpoint" },
		{ "<leader>Dt", dap.terminate, desc = "DAP Terminate" },
		{ "<f4>", dap.run, desc = "DAP Run" },
		{ "<f5>", dap.step_over, desc = "DAP Step over" },
		{ "<f6>", dap.step_into, desc = "DAP Step into" },
		{ "<f7>", dap.continue, desc = "DAP Continue" },
		{ "<f8>", dap.step_out, desc = "DAP Step out" },
		{ "<f1>", dap.run_last, desc = "DAP Run last" },
	},
	-- m4 >>>)
}
