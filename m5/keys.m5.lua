local vim = vim
local telescope = require "telescope"
local builtin = require "telescope.builtin"
--+ if !sergey
local dap = require "dap"
--+ end

--+ if !danin
--- returns visual mode selection as string
--- @return string
local function get_selection()
	local s = vim.fn.getpos "v"
	local e = vim.fn.getpos "."
	local lines = vim.fn.getregion(s, e, { type = vim.fn.mode() })
	return table.concat(lines, "\n")
end

--- escapes special characters that wouldn't be matched by /-search by themselves
--- @param str string
--- @return string
local function escape(str)
	local result = str
		:gsub("\\", "\\\\")
		:gsub("/", "\\/")
		:gsub("%*", "\\*")
		:gsub("%[", "\\[")
		:gsub("%]", "\\]")
	return result
end

--- pastes selected text into the search-n-replace ex command
--- @return nil
local function replace_from_sel()
	local sel = get_selection()
	local input = escape(sel)
	local pat = "<esc>:%s/" .. input .. "/" .. "/g<left><left>"
	local keys = vim.api.nvim_replace_termcodes(pat, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end

--- pastes selected text into the search-n-replace ex command
--- @return nil
local function replace_from_sel_prefilled()
	local sel = get_selection()
	local input = escape(sel)
	local pat = "<esc>:%s/" .. input .. "/" .. input .. "/g<left><left>"
	local keys = vim.api.nvim_replace_termcodes(pat, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end
--+ end

require "which-key".add {
	--+ if sergey
	-- aldivim config
	{ "<leader>n", group = "aldivim" },
	{ "<leader>ni", ":e ~/.config/nvim/m5/init.m5.lua<cr>", desc = "Open aldivim's imports config" },
	{ "<leader>nk", ":e ~/.config/nvim/m5/keys.m5.lua<cr>", desc = "Open aldivim's key config" },
	{ "<leader>nl", ":e ~/.config/nvim/m5/lsp.m5.lua<cr>", desc = "Open aldivim's lsp config" },
	{ "<leader>no", ":e ~/.config/nvim/m5/opts.m5.lua<cr>", desc = "Open aldivim's core config" },
	{ "<leader>np", ":e ~/.config/nvim/m5/lazy.m5.lua<cr>", desc = "Open aldivim's plugin config" },

	-- other configs
	{ "<leader>,", group = "config" },
	{ "<leader>,f", ":e ~/.config/fish/config.fish<cr>", desc = "Open shell config" },
	{ "<leader>,s", ":e ~/.config/sway/config<cr>", desc = "Open window manager config" },

	-- norsu
	{ "<leader>w", group = "norsu" },
	{ "<leader>wo",
		function()
			builtin.find_files { cwd = "~/stuff/writing" }
		end, desc = "Find writing wiki pages" },
	{ "<leader>wb", ":e NorsuBacklinks<cr>", desc = "Show this notes's backlinks" },
	{ "<leader>wd", ":e NorsuDelete<cr>", desc = "Delete this note" },
	{ "<leader>wr", ":e NorsuRename<cr>", desc = "Rename this note" },

	-- norsu etc.
	{ "<tab>", ":NorsuLinkNext<cr>", desc = "Go to next Norsu link" },
	{ "<s-tab>", ":NorsuLinkPrev<cr>", desc = "Go to previous Norsu link" },
	{ "<cr>", ":NorsuLinkEnter<cr>", desc = "Follow Norsu link" },
	{ "<bs>", "<c-o>", desc = "Jump back" },
	{ "<c-bs>", "<c-i>", desc = "Jump forward" },
	{ "<leader>a", ":e ~/stuff/norsu/Aufgaben.no<cr>", desc = "Open tasks wiki page" },
	{ "<leader>o",
		function()
			builtin.find_files { cwd = "~/stuff/norsu" }
		end, desc = "Find wiki pages" },
	{ "<leader>p", ":e ~/stuff/norsu/Programmieren.no<cr>", desc = "Open programming wiki page" },
	{ "<leader>u",
		function()
			builtin.find_files { cwd = "~/uni/norsu" }
		end, desc = "Find uni pages" },
	--+ end

	-- editing
	{ "<leader><leader>", ":w<cr>", desc = "Save file" },
	{ "<leader>s", function() vim.wo.wrap = not vim.wo.wrap end, desc = "Toggle wrap" },
	{ "<leader>q", ":q!<cr>", desc = "Quit without saving" },
	{ "<leader>Q", ":restart<cr>", desc = "Restart neovim" },
	{ "<leader>z", ":wq<cr>", desc = "Save and quit" },

	-- split panes
	{ "<leader>h", ":vs +wincmd\\ h<cr>", desc = "Split pane left" },
	{ "<leader>j", ":sp<cr>", desc = "Split pane down" },
	{ "<leader>k", ":sp +wincmd\\ k<cr>", desc = "Split pane up" },
	{ "<leader>l", ":vs<cr>", desc = "Split pane right" },

	-- telescope
	{ "<leader><f1>", builtin.help_tags, desc = "View all help pages" },
	{ "<leader>.", builtin.oldfiles, desc = "View recent files" },
	{ "<leader>b", builtin.buffers, desc = "View open buffers" },
	--+ if sergey
	{ "<leader>c",
		function()
			builtin.colorscheme { enable_preview = true }
		end, desc = "Change colorscheme" },
	--+ else
	{ "<leader>C",
		function()
			builtin.colorscheme { ignore_builtins = true }
		end, desc = "Change colorscheme" },
	--+ end
	{ "<leader>d",
		function()
			builtin.diagnostics { bufnr = 0, line_width = "full" }
		end, desc = "View LSP diagnostics" },
	{ "<leader>e", telescope.extensions.file_browser.file_browser, desc = "Browse files" },
	{ "<leader>f", builtin.find_files, desc = "Find files in this directory" },
	{ "<leader>g", builtin.live_grep, desc = "Grep in this directory" },
	--+ if sergey
	{ "<leader>r", builtin.resume, desc = "Open last Telescope picker" },
	--+ end

	-- terminal
	{ "<leader>t", ":te<cr>", desc = "Open terminal" },

	-- lsp
	--+ if sergey
	{ "<leader>D",
		function()
			vim.diagnostic.open_float(nil, { focus = false })
		end, desc = "View full LSP message" },
	--+ else
	{ "<leader>r",
		function()
			vim.diagnostic.open_float(nil, { focus = false })
		end, desc = "View full LSP message" },
	--+ end
	--+ if !danin
	{ "K",
		function()
			vim.lsp.buf.hover { border = "single" }
		end, desc = "Show symbol information" },
	--+ end

	-- etc
	{ "<esc>", ":noh<cr>", desc = "Remove search highlights" },
	{ "<leader>m", ":make<cr>", desc = "Run compiler command" },
	{ "<leader>x",
		function()
			-- this implementation doesnt close the window the buffer was on,
			-- instead replacing it with another
			-- ":bp|bd#" didnt work, cause it couldnt close the last buffer
			local bufnr = vim.api.nvim_win_get_buf(0)
			vim.cmd.bprev()
			vim.cmd.bdelete(bufnr)
		end, desc = "Delete buffer" },
	{ "<leader>X", ":%bd|e#<cr>", desc = "Delete all other buffers" },
	--+ if sergey
	{ "<leader>i", ":ColorizerToggle<cr>", desc = "Toggle hex colorizer" },

	{
		mode = "i",

		-- insert-mode shell behavior
		{ "<m-backspace>", "<c-w>", desc = "Delete last word" },

		-- navigation
		{ "<c-h>", "<left>", desc = "Move left" },
		{ "<c-j>", "<down>", desc = "Move down" },
		{ "<c-k>", "<up>", desc = "Move up" },
		{ "<c-l>", "<right>", desc = "Move right" }
	},
	--+ else
	{ "<leader>y", ":ColorizerToggle<cr>", desc = "Toggle hex colorizer" },
	{ "<leader>i",
		function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, desc = "Toggle inlay hints" },
	--+ end

	{
		mode = "x", -- all visual modes

		--+ if sergey
		{ "<f1>",
			function()
				vim.cmd.help(get_selection())
			end, desc = "Open help page for selection" },
		--+ end
		{ ">", ">gv", desc = "Indent block and keep selection" },
		{ "<", "<gv", desc = "Deindent block and keep selection" },
		{ "<leader>r", replace_from_sel, desc = "Replace selected text" },
		{ "<leader>R", replace_from_sel_prefilled,
			desc = "Replace selected text (with suggestion)" }
	},

	{
		mode = { "n", "i" },

		-- lsp
		{ "<f2>", vim.lsp.buf.rename, desc = "Rename symbol under cursor" },
		{ "<f1>", function()
				vim.cmd.help(vim.fn.expand "<cword>")
			end, desc = "Open help page for word under cursor" }
	},

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

	--+ if !sergey
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
	--+ end
}

-- TODO NOW
-- keep clipboard content after pasing in line-visual mode
