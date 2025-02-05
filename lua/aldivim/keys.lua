local vim = vim
local ks = vim.keymap.set

vim.g.mapleader = " "

-- basic
ks("n", "<esc>", vim.cmd.nohlsearch) -- Esc in normal mode removes search highlights

-- editing
ks("i", "<m-i>", "<esc>") -- Alt-i goes back to normal mode
ks("i", "<m-backspace>", "<c-w>") -- delete the last word with Alt-Backspace

-- writing
ks("n", "<leader><leader>", vim.cmd.write) -- Space-Space saves the file
ks("n", "<leader>z", vim.cmd.wq) -- Space-z saves and quits, like ZZ
ks("n", "<leader>q", ":q!<cr>") -- Space-q quits without saving

-- snippets
ks({ "i", "s" }, "<c-f>", function() vim.snippet.jump(1) end) -- jump between snippet placeholders Emacs-style
ks({ "i", "s" }, "<c-b>", function() vim.snippet.jump(-1) end)
