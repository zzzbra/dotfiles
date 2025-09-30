-- Set leader key BEFORE loading plugins
vim.g.mapleader = " "

-- Load plugins (using lazy.nvim)
require("aslan.lazy")

---------------------------------------------------------------------
--------------------------- OPTIONS ---------------------------------
---------------------------------------------------------------------
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.clipboard = "unnamedplus"

-- Increase timeout for leader key combinations
vim.opt.timeoutlen = 500

-- copilot
vim.g.copilot_assume_mapped = true


---------------------------------------------------------------------
--------------------------- MAPPINGS --------------------------------
---------------------------------------------------------------------
-- jj or jk to escape insert mode
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")

-- no more :W
vim.keymap.set("n", "<leader>;", ":")
vim.keymap.set("n", ":", "<nop>") -- good bye muscle memory

-- move up and down half page puts cursor in middle
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- moving lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- insert line below without entering insert mode
vim.keymap.set("n","<C-j>", "o<Esc>")
vim.keymap.set("n", "<C-k>", "O<Esc>")

-- toggle absolute line numbers
vim.keymap.set("n", "<leader>l", ":set rnu!<CR>")

-- copy to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- resizing panes
vim.keymap.set("n", "<C-w>h", "<C-w>5>")
vim.keymap.set("n", "<C-w>l", "<C-w>5<")

-- save hehe
vim.keymap.set("n", "<C-s>", ":w<CR>")

-- disable Q
vim.keymap.set("n", "Q", "<nop>")

-- split/join
vim.keymap.set("n", "gs", "<cmd>lua require('treesj').toggle()<CR>")

-- harpoon
vim.keymap.set("n", "<leader>0", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>")
vim.keymap.set("n", "<leader>`", "<cmd>lua require('harpoon.mark').add_file()<CR>")
vim.keymap.set("n", "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>")
vim.keymap.set("n", "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>")
vim.keymap.set("n", "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>")
vim.keymap.set("n", "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>")
vim.keymap.set("n", "<leader>5", "<cmd>lua require('harpoon.ui').nav_file(5)<CR>")

-- nvimtree
-- vim.keymap.set("n", "<leader>e", vim.cmd.Ex) -- netrw disabled
vim.keymap.set("n", "<leader>e", "<cmd>:NvimTreeFindFile<CR>zz")
vim.keymap.set("n", "<C-n>", "<cmd>:NvimTreeToggle<CR>")

-- lazygit open in new window
vim.keymap.set("n", "<leader>gg", ":!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazygit <CR><CR>", { silent = true })

-- github copilot
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- lsp
vim.keymap.set("n", "gd", "<cmd>:lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "gr", "<cmd>:lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "<leader>f", "<cmd>:lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR>")
vim.keymap.set("n", "<leader>.", "<cmd>:lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("v", "<leader>.", "<cmd>:lua vim.lsp.buf.range_code_action()<CR>")
vim.keymap.set("n", "<leader>d", "<cmd>:lua vim.diagnostic.open_float()<CR>")

-- diffview
vim.keymap.set("n", "<leader>dv", "<cmd>:DiffviewOpen<CR>")
vim.keymap.set("n", "<leader><Esc>", "<cmd>:tabclose<CR>")

-- Flutter
vim.keymap.set("n", "<leader>Fr", "<cmd>:FlutterRun --flavor dev<CR>")
vim.keymap.set("n", "<leader>Fo", "<cmd>:FlutterOutlineToggle<CR>")

---------------------------------------------------------------------
--------------------------- AUTOCOMMANDS ----------------------------
---------------------------------------------------------------------

vim.api.nvim_create_autocmd(
    "FileType", {
        pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact", "dart" },
        command = "setlocal ts=2 sts=2 sw=2 expandtab",
    }
)
