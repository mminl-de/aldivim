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
    }
}

require "aldivim.keys" -- key bindings
require "aldivim.opt" -- basic settings
require "aldivim.lsp"
