-- m4 undefine(`format')
-- m4 changequote(<<<, >>>)
local vim = vim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- put proper separators between custom lualine components
---@param sections table lualine section declarations
---@return table
local function separators_inbetween(sections)
	for _, section in pairs(sections) do
		for _, comp in ipairs(section) do
			comp.separator = { left = "🬙" }
		end
	end
	return sections
end

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
	"loctvl842/monokai-pro.nvim",
	"mofiqul/vscode.nvim",
	"olimorris/onedarkpro.nvim",
	"projekt0n/github-nvim-theme",
	"sainnhe/gruvbox-material",
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = { integrations = { vimwiki = true } }
	},
	{ "rose-pine/neovim", name = "rose-pine" },

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- the plugin I'm developing, DO NOT TOUCH
	{
		"hiimsergey/norsu.nvim",
		config = function() require "norsu".setup() end
	},
	-- m4 >>>)

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- personal knowledge management for me
	{
		"vimwiki/vimwiki",
		lazy = false,
		init = function()
			vim.g.vimwiki_list = {
				{ path = "~/stuff/vimwiki", index = "main" }
			}
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
				sections = separators_inbetween {
					-- m4 ifdef(<<<JULIAN>>>, <<<
					lualine_x = {
						{ "filetype" }
					},
					-- m4 >>>)
					lualine_z = {
						{ "location" },
						-- m4 ifdef(<<<SERGEY>>>, <<<
						{
							function() return vim.wo.wrap and "wrap" or "" end,
							icon = "󰖶",
							color = "@comment.todo"
						},
						{
							function() return vim.g.colorizer_on and "colorizer" or "" end,
							icon = "",
							color = "@comment.warning"
						},
						{
							function() return vim.g.inlay_hints_on and "inlay hints" or "" end,
							icon = "󰰤",
							color = "@comment.error"
						}
						-- m4 >>>)
					}
				}
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
				defaults = { mappings = { i = { ["<esc>"] = actions.close } } },
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
						hijack_netrw = true
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
					-- m4 ifdef(<<<SERGEY>>>, <<<>>>, <<<
					"cpp",
					"java",
					"xml",
					"json",
					"make",
					"dockerfile",
					"bash",
					"yaml",
					-- m4 >>>)
					"html",
					"css",
					"typescript",
					"python",
					"vimdoc",
					"rust",
					-- m4 ifdef(<<<DANIEL>>>, <<<
					"nix",
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
		-- decide whether we want plugins to be lazy by default
		-- and what need to be VeryLazy
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
					-- m4 ifdef(<<<JULIAN>>>, <<<
					["<cr>"] = cmp.mapping.confirm { select = true },
					-- m4 >>>, <<<
					["<tab>"] = cmp.mapping.confirm { select = true }
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
				view = { entries = "custom" },
				--window = {
				--	completion = cmp.config.window.bordered(),
				--	documentation = cmp.config.window.bordered()
				--},
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

	-- TODO NOTE julian wanted to decide between this and another plugin
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

	-- m4 ifdef(<<<JULIAN>>>, <<<>>>, <<<
	-- auto-pair html tags
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {
			opts = { enable_close_on_slash = true }
		}
	},
	-- m4 >>>)

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
    -- Highlights variable references
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
				load_breakpoints_event = { "BufReadPost"}
			}
		end,
	},

	{
		"carcuis/dap-breakpoints.nvim",
		config = function()
			require "dap-breakpoints".setup()
		end
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
