-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from lua/aslan/plugins/ directory
require("lazy").setup("aslan.plugins", {
  defaults = {
    lazy = false, -- plugins are not lazy-loaded by default
  },
  install = {
    colorscheme = { "miramare" }, -- try to load this colorscheme when starting
  },
  checker = {
    enabled = true, -- automatically check for plugin updates
    notify = false, -- don't notify on every startup
  },
  change_detection = {
    notify = false, -- don't notify when config file changes
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
