-- m4 changequote(<<<, >>>)
local lsp = vim.lsp
local capabilities = require "cmp_nvim_lsp".default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- enable every lsp service listed in the input
--@param lsps table lsp service declarations
local function load_lsps(lsps)
	for _, pair in ipairs(lsps) do
		lsp.config[pair.name] = pair.config or {}
		lsp.enable(pair.name)
	end
end

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

	-- m4 ifdef(<<<DANIN>>>, <<<>>>, <<<
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
	-- m4 >>>)

	-- m4 ifdef(<<<JULIAN>>>, <<<
	-- TODO add other lsps
	{ name = "jdtls" },
	{ name = "pyright" },
	-- m4 >>>)

	-- m4 ifdef(<<<DANIN>>>, <<<
	{ name = "slint_lsp" }
	-- m4 >>>)
}
