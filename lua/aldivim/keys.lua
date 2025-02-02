local vim = vim
local function n(keys, cmd) vim.keymap.set("n", keys, cmd) end
local function i(keys, cmd) vim.keymap.set("i", keys, cmd) end

-- snippets
vim.keymap.set({ "i", "s" }, "<c-f>", function() vim.snippet.jump(1) end)
vim.keymap.set({ "i", "s" }, "<c-b>", function() vim.snippet.jump(-1) end)