local vim = vim

-- where nvim plugins are stored
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim if we lose the nvim share folder
vim.keymap.set("n", "<leader>bl", function()
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
            { "\nPress any key to exit..." }
        }, true, {})
    end
    print "Installed lazy.nvim successfully! Please restart nvim!"
end)

vim.opt.rtp:prepend(lazypath)

require "lazy".setup {
    -- themes
    "alexvzyl/nordic.nvim",
    "navarasu/onedark.nvim",
    "rebelot/kanagawa.nvim",
    "sainnhe/gruvbox-material",
    "tiagovla/tokyodark.nvim",
    { "catppuccin/nvim", name = "catppuccin" },

    -- telescope (with file browser)
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local telescope = require "telescope"
            local fb_actions = telescope.extensions.file_browser.actions
            telescope.setup {
                extensions = {
                    hijack_netrw = true,
                    -- TODO mappings
                }
            }
        end
    },

    -- auto-pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },

    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require "nvim-treesitter.configs".setup {
                ensure_installed = { "lua", "vimdoc" },
                highlight = { enable = true },
                indent = { enable = true }
            }
        end
    },

    -- lsp
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Link to the docs for all of these:
            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#java_language_server
            -- https://github.com/bash-lsp/bash-language-server
            require "lspconfig".bashls.setup {}
            -- clang package
            require "lspconfig".clangd.setup {}
            -- https://github.com/hrsh7th/vscode-langservers-extracted
            require "lspconfig".html.setup {}
            -- https://github.com/georgewfraser/java-language-server
            require "lspconfig".java_language_server.setup {}
            -- https://biomejs.dev/
            require "lspconfig".biome.setup {}
            -- https://github.com/hrsh7th/vscode-langservers-extracted
            require "lspconfig".jsonls.setup {}
            -- https://github.com/latex-lsp/texlab
            require "lspconfig".texlab.setup {}
            -- https://github.com/luals/lua-language-server
            require "lspconfig".lua_ls.setup {}
            -- https://github.com/mtshiba/pylyzer
            require "lspconfig".pylyzer.setup {}
            -- https://github.com/zigtools/zls
            require "lspconfig".zls.setup {}
        end
    },

    -- completions
    {
        "hrsh7th/nvim-cmp",
        dependencies = "hrsh7th/cmp-nvim-lsp",
        config = function()
            local cmp = require "cmp"
            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                },
                mapping = cmp.mapping.preset.insert {
                    ["<c-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<c-d>"] = cmp.mapping.scroll_docs(4),
                    ["<c-Space>"] = cmp.mapping.complete(),
                    ["<c-x>"] = cmp.mapping.abort(),
                    ["<cr>"] = cmp.mapping.confirm { select = true }
                },
                sources = cmp.config.sources (
                    { { name = "nvim_lsp" } },
                    { name = "buffer" }
                ),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind_icons = {
                            Text = "",
                            Method = "󰆧",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "󰇽",
                            Variable = "󰂡",
                            Class = "󰠱",
                            Interface = "",
                            Module = "",
                            Property = "󰜢",
                            Unit = "",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "󰅲",
                        }

                        vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
                        vim_item.menu = ({
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[Lua]"
                        })[entry.source.name]
                        return vim_item
                    end
                },
                view = { entries = "native" }
            }

            -- necessary to make clangd completions not suck
            local capabilities = require "cmp_nvim_lsp".default_capabilities()
            require "lspconfig".clangd.setup { capabilities = capabilities }
        end
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require "lualine".setup {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '│', right = '│' }
                }
            }
        end
    },
    -- refactoring
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        lazy = false,
        config = function()
            require("refactoring").setup()
        end,
    },
}

require "aldivim.keys" -- key bindings
require "aldivim.opt" -- basic settings
