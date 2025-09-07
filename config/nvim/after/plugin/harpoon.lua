local w = math.floor(vim.api.nvim_win_get_width(0) * 0.65)
require("harpoon").setup({
    menu = {
       width = w,
    }
})
