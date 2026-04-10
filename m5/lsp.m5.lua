local vim = vim
local lsp = vim.lsp
local capabilities = require "cmp_nvim_lsp".default_capabilities()

--- enable every lsp service listed in the input
--- @param lsps table lsp service declarations
local function load_lsps(lsps)
	for _, pair in ipairs(lsps) do
		lsp.config[pair.name] = pair.config or {}
		lsp.enable(pair.name)
	end
end

capabilities.textDocument.completion.completionItem.snippetSupport = true

load_lsps {
	{
		name = "clangd",
		config = {
			cmd = {
				"clangd",
				"--clang-tidy",
				"--background-index",
				"--offset-encoding=utf-8"
			},
			root_markers = {},
			filetypes = { "c", "cpp", "h", "hpp" },
			capabilities = capabilities
		}
	},
	{
		name = "html",
		config = {
			cmd = { "vscode-html-language-server", "--stdio" },
			capabilities = capabilities
		}
	},
	{ name = "lua_ls" },
	{ name = "rust_analyzer" },
	{ name = "ts_ls" },
	{ name = "zls" },

	--+ if !danin
	{
		name = "dartls",
		config = {
			cmd = { "dart", "language-server", "--protocol=lsp" },
			init_options = { flutterOutline = true },
			root_markers = { "pubspec.yaml" },
			filetypes = { "dart" },
			settings = { dart = { completeFunctionCalls = true } }
		}
	},
	{
		name = "tinymist",
		config = {
			cmd = { "tinymist" },
			filetypes = { "typst" },
			root_markers = { ".git" }
		}
	},
	--+ end

	--+ if !sergey
	{ name = "jdtls" },
	{ name = "pyright" },
	--+ end

	--+ if julian
	{ name = "org" }
	--+ end
}
