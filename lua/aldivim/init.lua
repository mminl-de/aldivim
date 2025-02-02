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

    -- lsp
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "lspconfig".clangd.setup {}
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
                    completion = cmp.config.window.bordered()
                    documentation = cmp.config.window.bordered()
                },
                mapping = cmp.mapping.preset.insert {
                    ["<c-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<c-d>"] = cmp.mapping.scroll_docs(4),
                    ["<c-Space>"] = cmp.mapping.complete(),
                    ["<c-x>"] = cmp.mapping.abort(),
                    ["<cr>"] = cmp.mapping.confirm { select = true }
                },
                sources = cmp.config.source (
                    { { name = "nvim_lsp" } },
                    { name = "buffer" }
                )

                local capabilities = require "cmp_nvim.lsp".default_capabilities()
                require "lspconfig".clangd.setup {
                    capabilities = capabilities
                }
            }
        end
    }
}

require "aldivim.keys" -- key bindings
require "aldivim.opt" -- basic settings