-- m4 undefine(`format')
-- m4 changequote(<<<, >>>)
local vim = vim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- put proper separators between custom lualine components
---@param sections table lualine section declarations
---@return table
local function process_sections(sections)
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

require "lazy".setup {
	-- colorschemes/themes
	"loctvl842/monokai-pro.nvim",
	"marko-cerovac/material.nvim",
	"mofiqul/vscode.nvim",
	"olimorris/onedarkpro.nvim",
	"projekt0n/github-nvim-theme",
	"sainnhe/gruvbox-material",
	"tiagovla/tokyodark.nvim",
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require "catppuccin".setup {
				integrations = { vimwiki = true }
			}
		end
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
		init = function()
			vim.g.vimwiki_list = {
				{
					path = "~/stuff/vimwiki",
					index = "main"
				}
			}
		end
	},
	-- m4 >>>)

	-- launchers, pickers, prompts ...
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require "nvim-treesitter.configs".setup {
				ensure_installed = { "lua", "vimdoc", "zig" },
				highlight = { enable = true },
				indent = { enable = true }
			}
		end
	},

	-- file browser
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

	-- always show current scope you're in at the top
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function() require "treesitter-context".setup() end
	},

	-- highlight scopes
	{
		"lukas-reineke/indent-blankline.nvim",
		version = "v2.20.8",
		config = function()
			require "indent_blankline".setup {
				indent = { char = "│" },
				show_current_context = true
			}
		end
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.opt.signcolumn = "yes"
			local lspconfig = require "lspconfig"
			lspconfig.clangd.setup {
				cmd = { "clangd", "--compile-commands-dir=build", "-x", "c" }
			}
			lspconfig.html.setup {}
			lspconfig.lua_ls.setup {}
			lspconfig.ts_ls.setup {}
			-- m4 ifdef(<<<DANIN>>>, <<<
			lspconfig.rust_analyzer.setup {}
			lspconfig.slint_lsp.setup {}
			-- m4 >>>)
			--lspconfig.zls.setup {}
			-- m4 ifdef(<<<JULIAN>>>, <<<
			-- TODO add other lsps
			lspconfig.jdtls.setup {}
			lspconfig.pyright.setup {}
			-- m4 >>>)

			-- show LSP errors inline
			vim.diagnostic.config({
				virtual_text = {
					spacing = 2,
					prefix = "●",
				},
				signs = true,
				underline = true,
				update_in_insert = false,
			})
		end
	},

	-- m4 ifdef(<<<DANIN>>>, <<<
	-- LSP loading notification
	{
		"j-hui/fidget.nvim",
		lazy = false,
		config = true
	},
	-- m4 >>>)

	-- LSP-based autocompletions
	{
		"hrsh7th/nvim-cmp",
		dependencies = "hrsh7th/cmp-nvim-lsp",
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
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							nvim_lua = "[Lua]"
						})[entry.source.name]
						return vim_item
					end
				},
				mapping = cmp.mapping.preset.insert {
					["<c-u>"] = cmp.mapping.scroll_docs(-4),
					["<c-d>"] = cmp.mapping.scroll_docs(4),
					["<c-space>"] = cmp.mapping.complete(),
					["<c-x>"] = cmp.mapping.abort(),
					["<cr>"] = cmp.mapping.confirm { select = true }
				},
				snippet = { expand = function(args) vim.snippet.expand(args.body) end },
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" }
				},
				view = { entries = "native" },
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered()
				},
			}

			-- necessary to make clangd completions not suck
			local capabilities = require "cmp_nvim_lsp".default_capabilities()
			require "lspconfig".clangd.setup { capabilities = capabilities }
		end
	},

	{
		"ray-x/lsp_signature.nvim", -- TODO NOW
		event = "InsertEnter",
		config = function() require "lsp_signature".setup() end
	},

	-- bar
	{
		"nvim-lualine/lualine.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require "lualine".setup {
				options = {
					icons_enabled = true,
					theme = "auto",
					section_separators = { left = "𜷄", right = "𜵟" },
					component_separators = { left = "𜹘", right = "𜹘" }
				},
				sections = process_sections {
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
						-- m4 >>>)
						{
							function() return vim.g.goyo_on and "zen" or "" end,
							icon = "󱅻",
							color = "@comment.error"
						},
					}
				}
			}
		end
	},

	-- auto-pair brackets and quotes
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true
	},

	-- paint hexcodes
	{
		"norcalli/nvim-colorizer.lua",
		-- m4 ifdef(<<<JULIAN>>>, <<<
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

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- m4 >>>, <<<
	{
		'numToStr/Comment.nvim',
		opts = {
			padding = true,
			sticky = true,
			toggler = {
				line = '<leader>cc',
				block = '<leader>bc',
			},
			-- LHS of operator-pending mappings in NORMAL and VISUAL mode
		    opleader = {
				line = '<leader>cC',
				block = '<leader>cb',
			},
			extra = {
				-- Add comment on the line above
				above = '<leader>cO',
				-- Add comment on the line below
				below = '<leader>co',
				-- Add comment at the end of line
				eol = '<leader>cA',
			},
			mappings = {
				basic = true,
				extra = true,
			},
		}
	},
	-- m4 >>>)


	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- m4 >>>, <<<
	{
		"RRethy/vim-illuminate",
		config = function()
			require('illuminate').configure({
				min_count_to_highlight = 2
			})
		end
	},
	-- m4 >>>)

	-- m4 ifdef(<<<SERGEY>>>, <<<
	-- zen mode
	{
		"junegunn/goyo.vim",
		init = function()
			vim.g.goyo_width = 90
			vim.g.goyo_height = 100
			vim.g.goyo_linenr = true
		end
	}
	-- m4 >>>)
}
