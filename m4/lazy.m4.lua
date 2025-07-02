-- m4 undefine(`format')
-- m4 changequote(<<<, >>>)
local vim = vim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- Put proper separators between custom lualine components
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
    {
        "hiimsergey/norsu.nvim",
        config = function() require "norsu".setup() end
    },
    -- m4 >>>)

    -- m4 ifdef(<<<SERGEY>>>, <<<
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

    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require "treesitter-context".setup()
        end
    },

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
            lspconfig.zls.setup {}
            -- m4 ifdef(<<<JULIAN>>>, <<<
            -- TODO add other lsps
            lspconfig.jdtls.setup {}
            lspconfig.pyright.setup {}
            -- m4 >>>)
        end
    },

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

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },

	-- m4 ifdef(<<<JULIAN>>>, <<<
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
			vim.opt.termguicolors = true
            require 'colorizer'.setup()
        end
    },
	-- m4 >>>, <<<
	"norcalli/nvim-colorizer.lua",
	-- m4 >>>)

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
            icons = { mappings = false },
            delay = 300
        }
    },

    {
        "junegunn/goyo.vim",
        init = function()
            vim.g.goyo_width = 90
            vim.g.goyo_height = 100
            vim.g.goyo_linenr = true
        end
    }
}
