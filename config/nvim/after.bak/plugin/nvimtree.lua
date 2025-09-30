-- examples for your init.lua

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup({
    view = {
        width = "40%",
        side = "left",
    },
    filters = {
        dotfiles = false,
    },
    git = {
        enable = true,
        ignore = false,
    }
})
