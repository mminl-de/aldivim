local vim = vim
local ks = vim.keymap.set

vim.g.mapleader = " "

-- basic
ks({ "n", }, "<leader><leader>", vim.cmd.write)
ks({ "n" }, "<leader>z", vim.cmd.wq)
ks({ "n" }, "<leader>q", vim.cmd.quit)
ks({ "i" }, "<m-i>", "<esc>")
ks({ "i" }, "<m-backspace>", "<c-w>")
ks({ "n" }, "<esc>", vim.cmd.nohlsearch)

-- snippets
ks({ "i", "s" }, "<c-f>", function() vim.snippet.jump(1) end)
ks({ "i", "s" }, "<c-b>", function() vim.snippet.jump(-1) end)
