return {
  -- Plenary (required by many plugins)
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },
    config = function()
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      -- Setup keymaps
      vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<C-p>", builtin.builtin, { desc = "Telescope builtin" })
      vim.keymap.set("n", "<leader>pg", builtin.git_files, { desc = "Git files" })
      vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "LSP references" })
      vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "LSP definitions" })
      vim.keymap.set("n", "<leader>t", builtin.resume, { desc = "Resume last search" })
      vim.keymap.set("n", "<leader>gd", builtin.diagnostics, { desc = "Diagnostics" })

      require("telescope").setup({
        pickers = {
          find_files = {
            hidden = true,
            follow = true,
            no_ignore = true,
            no_ignore_parent = true,
          },
          git_files = {
            hidden = true,
            follow = true,
          },
          live_grep = {
            hidden = true,
            follow = true,
          },
        },
        defaults = {
          layout_strategy = "vertical",
          path_display = { truncate = 2 },
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
            },
            n = {
              ["q"] = actions.close,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
            }
          },
        },
      })

      -- Load fzf extension if available
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>0", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Harpoon menu" },
      { "<leader>`", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Harpoon mark file" },
      { "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "Harpoon file 1" },
      { "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "Harpoon file 2" },
      { "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "Harpoon file 3" },
      { "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "Harpoon file 4" },
      { "<leader>5", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", desc = "Harpoon file 5" },
    },
    config = function()
      local w = math.floor(vim.api.nvim_win_get_width(0) * 0.65)
      require("harpoon").setup({
        menu = {
          width = w,
        }
      })
    end,
  },

  -- Nvim Tree file explorer
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeFindFile<cr>zz", desc = "Find file in tree" },
      { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    config = function()
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

      -- Auto open nvim-tree when opening a directory
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          local directory = vim.fn.isdirectory(data.file) == 1
          if directory then
            vim.cmd.cd(data.file)
            require("nvim-tree.api").tree.open()
          end
        end,
      })
    end,
  },

  -- Leap motion plugin
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    event = "VeryLazy",
    config = function()
      vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
      vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
      vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')
    end,
  },
}
