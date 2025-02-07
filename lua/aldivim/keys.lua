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

-- buffers
ks("n", "<leader>x", vim.cmd.bdelete)
ks("n", "<leader><tab>", vim.cmd.bnext)
ks("n", "<leader><s-tab>", vim.cmd.bprev)

-- panes
for _, d in ipairs { "h", "j", "k", "l" } do
    ks({ "n", "i" }, "<m-" .. d .. ">", function() vim.cmd.wincmd(d) end)
end

ks("n", "<leader>j", function()
    vim.cmd.split()
    vim.cmd.wincmd "j"
end)

ks("n", "<leader>l", function()
    vim.cmd.vsplit()
    vim.cmd.wincmd "l"
end)

-- resizing panes
ks("n", "<m-<>", function() vim.cmd "vertical resize -8" end)
ks("n", "<m-s-<>", function() vim.cmd "vertical resize +8" end)
ks("n", "<m-->", function() vim.cmd "vertical resize -4" end)
ks("n", "<m-+>", function() vim.cmd "vertical resize +4" end)

-- snippets
ks({ "i", "s" }, "<c-f>", function() vim.snippet.jump(1) end) -- jump between snippet placeholders Emacs-style
ks({ "i", "s" }, "<c-b>", function() vim.snippet.jump(-1) end)

-- telescope
local telescope = require "telescope"
local builtin = require "telescope.builtin"
ks("n", "<leader>b", builtin.buffers)
ks("n", "<leader>e", telescope.extensions.file_browser.file_browser)
ks("n", "<leader>f", builtin.find_files)
ks("n", "<leader>t", builtin.colorscheme)
