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
        }
    },
}

require "aldivim.keys" -- key bindings
require "aldivim.opt" -- basic settings
