local vim = vim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

vim.opt.rtp:prepend(lazypath)

-- bootstrap lazy.nvim for if we lose the nvim share directory
vim.keymap.set("n", "<leader>l", function()
	print "Installing lazy.nvim..."
	local status = vim.system({
		"git", "clone", "--filter=blob:none", "--depth=1",
		"https://github.com/folke/lazy.nvim",
		lazypath
	}, { text = true }):wait()
	if status.code ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ status.stderr, "ErrorMsg" },
			{ "Press any key to exit..." }
		}, true, {})
		return
	end
	print "Installed lazy.nvim successfully! Please restart nvim!"
end, { desc = "Bootstrap lazy.nvim" })

local kind_icons = {
	Text = "", Method = "󰆧", Function = "󰊕", Constructor = "",
	Field = "󰇽", Variable = "󰂡", Class = "󰠱", Interface = "",
	Module = "", Property = "󰜢", Unit = "", Value = "󰎠",
	Enum = "", Keyword = "󰌋", Snippet = "󰅪", Color = "󰏘",
	File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
	Constant = "󰏿", Struct = "", Event = "", Operator = "󰆕",
	TypeParameter = "󰅲",
}

--+ if !danin
--- recolors nvim-cmp windows to use proper colors across colorschemes
--- @return nil
local function recolor_cmp()
	local bg = vim.api.nvim_get_hl(
		0,
		{ name = "NormalFloat", link = false}
	).bg

	for kind in pairs(kind_icons) do
		local hl_name = "CmpItemKind" .. kind
		local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })

		if hl.fg then
			vim.api.nvim_set_hl(0, hl_name, { fg = bg, bg = hl.fg })
		end
	end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = recolor_cmp })
--+ end

require "lazy".setup({
	-- colorschemes
	"loctvl842/monokai-pro.nvim",
	"folke/tokyonight.nvim",
	"mofiqul/vscode.nvim",
	"projekt0n/github-nvim-theme",
	"sainnhe/gruvbox-material",
	--+ if sergey
	"blazkowolf/gruber-darker.nvim",
	--+ end
	--+ if julian
	"olimorris/onedarkpro.nvim",
	"tiagovla/tokyodark.nvim",
	--+ end
	{ "catppuccin/nvim", name = "catppuccin" },

	--+ if sergey
	-- plugin i'm developing, DO NOT TOUCH
	{
		"hiimsergey/norsu.nvim",
		dependencies = "hiimsergey/tree-sitter-norsu",
		lazy = false,
		ft = "norsu",
		config = function()
			require "norsu".setup()
			vim.opt.conceallevel = 2
			vim.filetype.add { extension = { no = "norsu" } }
			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					require "nvim-treesitter.parsers".norsu = {
						install_info = {
							url = "https://github.com/hiimsergey/tree-sitter-norsu",
							branch = "dev",
							queries = "queries/norsu"
						},
					}
				end
			})
		end
	},
	--+ end

	--+ if !julian
	-- icons for other plugins
	"nvim-tree/nvim-web-devicons",
	--+ end

	--+ if danin
	-- bar
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		config = function()
			require "lualine".setup {
				options = {
					icons_enabled = true,
					theme = "auto",
					section_separators = { left = "𜷄", right = "𜵟" },
					component_separators = { left = "𜹘", right = "𜹘" }
				},
				--+ if !danin
				sections = {
					lualine_x = {
						--+ if sergey
						"encoding",
						--+ end
						"filetype"
					}
				}
				--+ end
			}
		end
	},
	--+ end

	-- launchers, pickers, prompts and file browser
	{
		"nvim-telescope/telescope-file-browser.nvim",
		event = "VeryLazy",
		keys = "<leader>e",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim"
		},
		config = function()
			local telescope = require "telescope"
			local actions = require "telescope.actions"
			--+ if !danin
			local borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }
			--+ end

			telescope.setup {
				defaults = {
					--+ if !danin
					borderchars = borderchars,
					layout_config = { height = 0.7 },
					--+ end
					mappings = { i = { ["<esc>"] = actions.close, } }
				},
				pickers = {
					colorscheme = {
						layout_config = {
							width = 0.3,
							height = 0.5,
							preview_cutoff = math.huge
						}
					},
					diagnostics = {
						layout_strategy = "vertical",
						layout_config = {
							width = 0.8,
							height = 0.5,
							mirror = true
						}
					},
					live_grep = {
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
			local langs = {
				"c",
				"css",
				"html",
				"javascript",
				"lua",
				"python",
				"rust",
				"typescript",
				"vimdoc",
				"zig",
				--+ if sergey
				"norsu",
				--+ else
				"bash",
				"cpp",
				"dockerfile",
				"java",
				"json",
				"make",
				"xml",
				"yaml",
				--+ end
				--+ if danin
				"nix",
				"tsx",
				--+ else if julian
				"dart",
				"diff",
				"editorconfig",
				"regex",
				"sxhkdrc",
				--+ end
			}
			require "nvim-treesitter".install(langs)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = langs,
				callback = function() vim.treesitter.start() end
			})
		end
	},

	--+ if sergey
	-- TODO REMOVE
	-- traverse syntax trees with treesitter
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function() vim.g.no_plugin_maps = true end,
		config = function()
			require "nvim-treesitter-textobjects".setup {
				-- dont pollute the jumplist
				move = { set_jumps = false }
			}
		end
	},
	--+ end

	-- always show current scope you're in at the top
	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = false,
		config = function() require "treesitter-context".setup() end
	},

	--+ if !sergey
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
	--+ end

	-- default lsp configs
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			vim.opt.signcolumn = "yes"

			-- show lsp errors inline
			vim.diagnostic.config {
				virtual_text = {
					spacing = 2,
					prefix = "󱈸",
				},
				float = {
					source = "always",
					--+ if !danin
					border = "single"
					--+ end
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
			}
		end
	},

	-- lsp-based autocompletions
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			--+ if julian
			"hrsh7th/cmp-nvim-lsp-signature-help"
			--+ end
		},
		event = "VeryLazy",
		config = function()
			local cmp = require "cmp"
			cmp.setup {
				formatting = {
					fields = {
						"kind", "abbr",
						--+ if danin
						"menu"
						--+ end
					},
					format = function(entry, item)
						--+ if !danin
						local icon = kind_icons[item.kind] or ""
						item.kind = " " .. icon .. " "
						--+ else
						item.kind = kind_icons[item.kind] .. " " .. item.kind
						item.menu = ({
							buffer = "[buf]",
							nvim_lsp = "[lsp]",
							nvim_lua = "[lua]"
						})[entry.source.name]
						--+ end

						return item
					end
				},
				mapping = cmp.mapping.preset.insert {
					["<c-u>"] = cmp.mapping.scroll_docs(-4),
					["<c-d>"] = cmp.mapping.scroll_docs(4),
					["<c-space>"] = cmp.mapping.complete(),
					["<c-x>"] = cmp.mapping.abort(),
					--+ if sergey
					["<tab>"] = cmp.mapping.confirm { select = true },
					--+ else
					["<cr>"] = cmp.mapping.confirm { select = true },
					--+ end
				},
				snippet = {
					expand = function(args) vim.snippet.expand(args.body) end
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					--+ if !sergey
					{ name = "nvim_lsp_signature_help" }
					--+ end
				},
				view = { entries = "custom" },
				--+ if !danin
				window = {
					completion = { border = "single", side_padding = 0, col_offset = 1 },
					documentation = { border = "single" }
				}
				--+ end
			}
		end
	},

	--+ if !julian
	-- show function signature when writing them out
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			--+ if !danin
			handler_opts = { border = "single" },
			--+ end
			hint_enable = false
		}
	},
	--+ end

	--+ if !julian
	-- lsp loading notification
	{
		"j-hui/fidget.nvim",
		lazy = false,
		config = true
	},
	--+ end

	-- auto-pair brackets and quotes
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local ap = require "nvim-autopairs"
			local Rule = require "nvim-autopairs.rule"

			ap.setup { check_ts = true }

			-- space expansion: {|} -> { | }
			local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
			ap.add_rules {
				Rule(" ", " ")
				:with_pair(function (opts)
					local pair = opts.line:sub(opts.col - 1, opts.col)
					return vim.tbl_contains({
						brackets[1][1] .. brackets[1][2],
						brackets[2][1] .. brackets[2][2],
						brackets[3][1] .. brackets[3][2],
					}, pair)
				end)
			}
		end
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
		--+ if sergey
		event = "VeryLazy",
		--+ else
		config = function()
			vim.opt.termguicolors = true
			require "colorizer".setup()
		end
		--+ end
	},

	-- key bindings overview
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			icons = { mappings = false },
			delay = 300,
			--+ if !danin
			win = { border = "single" }
			--+ end
		}
	},

	--+ if !sergey
    -- highlights all occurences of current word
	{
		"rrethy/vim-illuminate",
		lazy = false,
		config = function()
			require "illuminate".configure { min_count_to_highlight = 2 }
		end
	},

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
	--+ end

	-- collaborative coding
	{
		"azratul/live-share.nvim",
		-- dependencies = "jbyuki/instant.nvim",
		--+ if !sergey
		lazy = false,
		--+ end
		config = function()
			-- --+ if julian
			-- vim.g.instant_username = "julian"
			-- --+ else if sergey
			-- vim.g.instant_username = "sergey"
			-- --+ else if danin
			-- vim.g.instant_username = "danin"
			-- --+ end
			require "live-share".setup {}
		end
	},

	--+ if julian
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		config = function()
			require "orgmode".setup{
				org_agenda_files = "~/doc/org/**/*",
				org_default_notes_file = "~/doc/org/refile.org",
			}
		end,
	},
	--+ end

}, {
	--+ if sergey
	change_detection = { enabled = false },
	checker = { enabled = false },
	install = { missing = false },
	defaults = { lazy = true }
	--+ end
})
