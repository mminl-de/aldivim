-- m4 undefine(`format')
-- m4 changequote(<<<, >>>)
local vim = vim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim for if i lose the nvim share directory
vim.keymap.set("n", "<leader>l", function()
	print "Installing lazy.nvim..."
	local stat = vim.fn.system {
		"git", "clone", "--filter=blob:none", "--depth=1",
		"https://github.com/folke/lazy.nvim",
		lazypath
	}
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ stat, "WarningMsg" },
			{ "Press any key to exit..." }
		}, true, {})
		return
	end
	print "Installed lazy.nvim successfully! Please restart nvim!"
end, { desc = "Bootstrap lazy.nvim" })

vim.opt.rtp:prepend(lazypath)

require "lazy".setup({
	-- colorschemes
	"alexvzyl/nordic.nvim",
	"loctvl842/monokai-pro.nvim",
	"mofiqul/vscode.nvim",
	"projekt0n/github-nvim-theme",
	"sainnhe/gruvbox-material",
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "rose-pine/neovim", name = "rose-pine" },
	-- m4 ifdef(<<<JULIAN>>>, <<<
	"olimorris/onedarkpro.nvim",
	"tiagovla/tokyodark.nvim",
	-- m4 >>>, <<<
	"navarasu/onedark.nvim",
	-- m4 >>>)

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- plugin i'm developing, DO NOT TOUCH
	{
		"hiimSERGEY/norsu.nvim",
		lazy = false,
		dependencies = "hiimSERGEY/tree-sitter-norsu",
		config = function()
			require "norsu".setup()
			-- m4 ifdef(<<<SERGEY>>>, <<<
			require "nvim-treesitter.parsers".get_parser_configs().norsu = {
				install_info = {
					url = "https://github.com/hiimSERGEY/tree-sitter-norsu",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "dev"
				},
			}
			vim.filetype.add { extension = { no = "norsu" } }
			-- m4 >>>)
		end
	},
	-- m4 >>>)

	-- bar
	{
		"nvim-lualine/lualine.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = false,
		config = function()
			require "lualine".setup {
				options = {
					icons_enabled = true,
					theme = "auto",
					section_separators = { left = "𜷄", right = "𜵟" },
					component_separators = { left = "𜹘", right = "𜹘" }
				},
				-- m4 ifdef(<<<DANIN>>>, <<<>>>, <<<
				sections = {
					lualine_x = {
						-- m4 ifdef(<<<SERGEY>>>, <<<
						"encoding",
						-- m4 >>>)
						"filetype"
					}
				}
				-- m4 >>>)
			}
		end
	},

	-- launchers, pickers, prompts and file browser
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim"
		},
		config = function()
			local telescope = require "telescope"
			local actions = require "telescope.actions"
			telescope.setup {
				defaults = { mappings = { i = { ["<esc>"] = actions.close, } } },
				pickers = {
					colorscheme = { theme = "dropdown" },
					diagnostics = {
						theme = "dropdown",
						layout_config = { width = 0.8 }
					}
				},
				extensions = {
					file_browser = {
						hidden = true,
						hijack_netrw = true,
						create_from_prompt = false
					},
				}
			}
			telescope.load_extension "file_browser"
		end
	},

	-- proper syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require "nvim-treesitter.configs".setup {
				ensure_installed = {
					"zig",
					"lua",
					"c",
					"python",
					"typescript",
					"vimdoc",
					"rust",
					-- m4 ifdef(<<<SERGEY>>>, <<<>>>, <<<
					"cpp",
					"java",
					"xml",
					"json",
					"make",
					"dockerfile",
					"bash",
					"yaml",
					"html",
					"css",
					-- m4 >>>)
					-- m4 ifdef(<<<DANIN>>>, <<<
					"nix",
					"tsx",
					-- m4 >>>)
					-- m4 ifdef(<<<JULIAN>>>, <<<
					"editorconfig",
					"regex",
					"sxhkdrc",
					"dart",
					"diff",
					-- m4 >>>)
				},
				highlight = { enable = true },
				indent = { enable = true }
			}
		end
	},

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- traverse syntax trees with treesitter
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		lazy = false, -- TODO
		init = function() vim.g.no_plugin_maps = true end,
		config = function()
			require "nvim-treesitter-textobjects".setup {
				-- dont pollute the jumplist
				move = { set_jumps = false }
			}
		end
	},
	-- m4 >>>)

	-- always show current scope you're in at the top
	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = false,
		config = function() require "treesitter-context".setup() end
	},

	-- m4 ifdef(<<<SERGEY>>>, <<<>>>, <<<
	-- highlight scopes
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		version = "v3.9.1",
		config = function()
			require "ibl".setup {
				scope = {
					show_start = false,
					show_end = false
				},
				indent = {
					char = "▏", -- default is "▎"
					repeat_linebreak = false,
				}
			}
		end
	},
	-- m4 >>>)

	-- lsp
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			vim.opt.signcolumn = "yes"

			-- show lsp errors inline
			vim.diagnostic.config({
				virtual_text = {
					spacing = 2,
					prefix = "󱈸",
				},
				float = {
					source = "always",
					border = "rounded"
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					}
				},
				underline = true,
				update_in_insert = false,
			})
		end
	},

	-- lsp-based autocompletions
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			-- m4 ifdef(<<<JULIAN>>>, <<<
			"hrsh7th/cmp-nvim-lsp-signature-help"
			-- m4 >>>)
		},
		event = "VeryLazy",
		config = function()
			local cmp = require "cmp"
			cmp.setup {
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind_icons = {
							Text = "", Method = "󰆧", Function = "󰊕", Constructor = "",
							Field = "󰇽", Variable = "󰂡", Class = "󰠱", Interface = "",
							Module = "", Property = "󰜢", Unit = "", Value = "󰎠",
							Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
							File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
							Constant = "󰏿", Struct = "", Event = "", Operator = "󰆕",
							TypeParameter = "󰅲",
						}

						vim_item.kind = string.format(
							"%s %s",
							kind_icons[vim_item.kind],
							vim_item.kind
						)
						vim_item.menu = ({
							buffer = "[buf]",
							nvim_lsp = "[lsp]",
							nvim_lua = "[lua]"
						})[entry.source.name]
						return vim_item
					end
				},
				mapping = cmp.mapping.preset.insert {
					["<c-u>"] = cmp.mapping.scroll_docs(-4),
					["<c-d>"] = cmp.mapping.scroll_docs(4),
					["<c-space>"] = cmp.mapping.complete(),
					["<c-x>"] = cmp.mapping.abort(),
					-- m4 ifdef(<<<SERGEY>>>, <<<
					["<tab>"] = cmp.mapping.confirm { select = true },
					-- m4 >>>, <<<
					["<cr>"] = cmp.mapping.confirm { select = true },
					-- m4 >>>)
				},
				snippet = { expand = function(args) vim.snippet.expand(args.body) end },
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					-- m4 ifdef(<<<SERGEY>>>, <<<>>>, <<<
					{ name = "nvim_lsp_signature_help" }
					-- m4 >>>)
				},
				view = { entries = "custom" }
			}
		end
	},

	-- m4 ifdef(<<<JULIAN>>>, <<<>>>, <<<
	-- lsp loading notification
	{
		"j-hui/fidget.nvim",
		lazy = false,
		config = true
	},
	-- m4 >>>)

	-- TODO NOTE JULIAN wanted to decide between this and another plugin
	-- show function signatures when writing them out
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			handler_opts = { border = "rounded" },
			hint_enable = false
		}
	},

	-- auto-pair brackets and quotes
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true
	},

	-- auto-pair html tags
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = { opts = { enable_close_on_slash = true } }
	},

	-- paint hexcodes
	{
		"norcalli/nvim-colorizer.lua",
		-- m4 ifdef(<<<SERGEY>>>, <<<
		event = "VeryLazy",
		-- m4 >>>, <<<
		config = function()
			vim.opt.termguicolors = true
			require "colorizer".setup()
		end
		-- m4 >>>)
	},

	-- key bindings overview
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			icons = { mappings = false },
			delay = 300
		}
	},

	-- m4 ifdef(<<<SERGEY>>>, <<<>>>, <<<
    -- highlights variable references
	{
		"rrethy/vim-illuminate",
		lazy = false,
		config = function()
			require "illuminate".configure { min_count_to_highlight = 2 }
		end
	},
	-- m4 >>>)

	-- m4 ifdef(<<<SERGEY>>>, <<<>>>, <<<
	"mfussenegger/nvim-dap",

	-- dap UI
	{
		"igorlfs/nvim-dap-view",
		opts = {},
	},

	-- This is a dependency for dap-breakpoints, but can be useful even without ig
	{
		"weissle/persistent-breakpoints.nvim",
		config = function()
			require "persistent-breakpoints".setup {
				load_breakpoints_event = { "BufReadPost" }
			}
		end,
	},

	{
		"carcuis/dap-breakpoints.nvim",
		config = function() require "dap-breakpoints".setup() end
	},
	-- m4 >>>)

	-- collaborative coding
	{
		"azratul/live-share.nvim",
		-- TODO dependencies = "jbyuki/instant.nvim",
		-- m4 ifdef(<<<SERGEY>>>, <<<>>>, <<<
		lazy = false,
		-- m4 >>>)
		config = function()
			-- m4 ifdef(<<<JULIAN>>>, <<<
			vim.g.instant_username = "julian"
			-- m4 >>>)
			-- m4 ifdef(<<<SERGEY>>>, <<<
			vim.g.instant_username = "sergey"
			-- m4 >>>)
			-- m4 ifdef(<<<DANIN>>>, <<<
			vim.g.instant_username = "danin"
			-- m4 >>>)
			require "live-share".setup {}
		end
	},

	-- m4 ifdef(<<<JULIAN>>>, <<<
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		config = function()
			require("orgmode").setup {
				org_agenda_files = "~/doc/org/**/*",
				org_default_notes_file = "~/doc/org/refile.org",
			}
		end,
	},
	-- m4 >>>)

}, {
	-- m4 ifdef(<<<SERGEY>>>, <<<
	change_detection = { enabled = false },
	checker = { enabled = false },
	install = { missing = false },
	defaults = { lazy = true }
	-- m4 >>>)
})
