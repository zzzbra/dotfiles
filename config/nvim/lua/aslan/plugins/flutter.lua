return {
  -- Dressing (better vim.ui)
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require('dressing').setup({})
    end,
  },

  -- Flutter tools
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    ft = "dart",
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun --flavor dev<cr>", desc = "Flutter run" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter outline toggle" },
    },
    config = function()
      require("flutter-tools").setup({
        -- flutter_path will auto-detect from PATH if not specified
        -- Uncomment and update if Flutter is not in your PATH:
        -- flutter_path = "/path/to/flutter/bin/flutter",
        dev_tools = {
          autostart = true,
          auto_open_browser = true,
        },
        widget_guides = {
          enabled = true,
          debug = true,
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
        },
      })

      -- Load flutter telescope extension if available
      pcall(require("telescope").load_extension, "flutter")
    end,
  },
}
