local vim = vim
local telescope = require "telescope"
local builtin = require "telescope.builtin"

vim.g.mapleader = " "

require "which-key".add {
    -- neovim config
    { "<leader>n", group = "neovim" },
    { "<leader>ni", function() vim.cmd.edit "~/.config/nvim/init.lua" end, desc = "Open nvim's init.lua" },
    { "<leader>nk", function() vim.cmd.edit "~/.config/nvim/lua/aldivim/keys.lua" end, desc = "Open nvim's key config" },
    { "<leader>nl", function() vim.cmd.edit "~/.config/nvim/lua/aldivim/lazy.lua" end, desc = "Open nvim's plugin config" },
    { "<leader>no", function() vim.cmd.edit "~/.config/nvim/lua/aldivim/opts.lua" end, desc = "Open nvim's core config" },
    { "<leader>nm", group = "aldivim" },
    { "<leader>nmk", function() vim.cmd.edit "~/.config/nvim/m4/keys.m4.lua" end, desc = "Open nvim's key config" },
    { "<leader>nml", function() vim.cmd.edit "~/.config/nvim/m4/lazy.m4.lua" end, desc = "Open nvim's plugin config" },
    { "<leader>nmo", function() vim.cmd.edit "~/.config/nvim/m4/opts.m4.lua" end, desc = "Open nvim's core config" },

    -- other configs
    { "<leader>c", group = "config" },
    { "<leader>cf", function() vim.cmd.edit "~/.config/fish/config.fish" end, desc = "Open shell config" },
    { "<leader>cs", function() vim.cmd.edit "~/.config/sway/config" end, desc = "Open window manager config" },

    -- editing
    { "<leader><leader>", vim.cmd.write, desc = "Save file" },
    { "<leader>z", vim.cmd.wq, desc = "Save and quit" },
    { "<leader>q", ":q!<cr>", desc = "Quit without saving" },
    { "<leader>k", function() vim.wo.wrap = not vim.wo.wrap end, desc = "Toggle wrap" },

    -- buffers
    { "<leader>x", vim.cmd.bdelete, desc = "Close buffer" },
    { "<leader><tab>", vim.cmd.bnext, desc = "Go to next buffer" },
    { "<leader><s-tab>", vim.cmd.bprev, desc = "Go to previous buffer" },

    -- split panes
    { "<leader>j", function() vim.cmd.split() vim.cmd.wincmd "j" end, desc = "Split pane down" },
    { "<leader>l", function() vim.cmd.vsplit() vim.cmd.wincmd "l" end, desc = "Split pane to the right" },

    -- resize panes
    { "<m-<>", function() vim.cmd "vertical resize -8" end, desc = "Shrink pane vertically" },
    { "<m-s-<>", function() vim.cmd "vertical resize +8" end, desc = "Grow pane vertically" },
    { "<m-->", function() vim.cmd "horizontal resize -4" end, desc = "Shrink pane horizontally" },
    { "<m-+>", function() vim.cmd "horizontal resize +4" end, desc = "Grow pane horizontally" },

    -- telescope
    { "<leader>.", builtin.oldfiles, desc = "View recent files" },
    { "<leader>b", builtin.buffers, desc = "View open buffers" },
    { "<leader>e", telescope.extensions.file_browser.file_browser, desc = "Browse files" },
    { "<leader>f", builtin.find_files, desc = "Find files in this directory" },
    { "<leader>t", builtin.colorscheme, desc = "Change colorscheme" },

    -- vimwiki
    { "<leader>a", function() vim.cmd.edit "~/stuff/vimwiki/Aufgaben.wiki" end, desc = "Open tasks wiki page" },
    { "<leader>d", builtin.diagnostics, desc = "View LSP diagnostics" },
    { "<leader>m", function() vim.cmd.edit "~/stuff/vimwiki/main.wiki" end, desc = "Open main wiki page" },
    { "<leader>o", function() vim.cmd.Telescope("find_files", "cwd=~/stuff/vimwiki") end, desc = "Find wiki pages" },
    { "<leader>p", function() vim.cmd.edit "~/stuff/vimwiki/Programmieren.wiki" end, desc = "Open programming wiki page" },
    { "<leader>u", function() vim.cmd.edit "~/stuff/vimwiki/Uni.wiki" end, desc = "Open uni wiki page" },
    { "<leader>w", function() vim.cmd.Telescope("find_files", "cwd=~/stuff/writing") end, desc = "Find writing wiki pages" },
    { "<leader>v", group = "vimwiki" },
    { "<leader>vb", vim.cmd.VimwikiBacklinks, desc = "Show this wiki page's backlinks" },
    { "<leader>vd", vim.cmd.VimwikiDeleteFile, desc = "Delete this wiki page" },
    { "<leader>vr", vim.cmd.VimwikiRenameFile, desc = "Rename this wiki page" },

    -- etc
    { "<esc>", vim.cmd.nohlsearch, desc = "Remove search highlights" },
    { "<leader>g", function() vim.cmd.Goyo() vim.g.goyo_on = not vim.g.goyo_on end, desc = "Toggle zen mode" },
    { "<leader>h", function() vim.cmd.ColorizerToggle() vim.g.colorizer_on = not vim.g.colorizer_on end, desc = "Toggle hex colorizer" },

    {
        mode = "i",

        { "<m-backspace>", "<c-w>", desc = "Delete last word" },

        -- vimwiki
        { "<c-8>", "[[]]<left><left>", desc = "Insert vimwiki link" },
        { "<m-0>", "==<left>", desc = "Insert vimwiki heading" },
    },

    {
        mode = { "n", "i" },

        -- focus panes
        { "<m-h>", function() vim.cmd.wincmd("h") end, desc = "Focus pane to the left" },
        { "<m-j>", function() vim.cmd.wincmd("j") end, desc = "Focus pane below" },
        { "<m-k>", function() vim.cmd.wincmd("k") end, desc = "Focus pane above" },
        { "<m-l>", function() vim.cmd.wincmd("l") end, desc = "Focus pane to the right" },

        -- lsp
        { "<f2>", vim.lsp.buf.rename, desc = "Rename symbol under cursor" }
    }
}
