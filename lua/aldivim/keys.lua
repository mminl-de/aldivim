local vim = vim
local ks = vim.keymap.set

-- Set <space> as leader key
vim.g.mapleader = " "

-- snippets
ks({ "i", "s" }, "<c-f>", function() vim.snippet.jump(1) end)
ks({ "i", "s" }, "<c-b>", function() vim.snippet.jump(-1) end)

-- refactor
ks("x", "<leader>re", ":Refactor extract ")
ks("x", "<leader>rf", ":Refactor extract_to_file ")
ks("x", "<leader>rv", ":Refactor extract_var ")
ks({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
ks( "n", "<leader>rI", ":Refactor inline_func")
