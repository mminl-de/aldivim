local lspconfig = require "lspconfig".clangd.setup {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "h", "hpp" },
    root_markers = { ".clangd", "compile_commands.json" }
}