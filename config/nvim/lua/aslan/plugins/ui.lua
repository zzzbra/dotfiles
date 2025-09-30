return {
  -- Color schemes
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = 'warm',
      })
      -- Set as default colorscheme
      require("onedark").load()
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = 'storm',
      })
    end,
  },
  {
    "franbach/miramare",
    lazy = false,
    priority = 1000,
    config = function()
      -- Set miramare as default colorscheme
      vim.cmd("colorscheme miramare")
    end,
  },

  -- tmux navigation
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    priority = 998,
    config = function()
      require('nvim-web-devicons').setup({
        override = {
          zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
          }
        },
        color_icons = true,
        default = true,
        strict = true,
        override_by_filename = {
          [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore"
          }
        },
        override_by_extension = {
          ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log"
          }
        },
      })
    end,
  },

  -- Indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
      require("ibl").setup({
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
          highlight = { "Function", "Label" },
        },
      })
    end,
  },

  -- Center buffer
  {
    "shortcuts/no-neck-pain.nvim",
    cmd = "NoNeckPain",
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 999,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local bg_color = '#2B2426'
      require('lualine').setup({
        options = {
          component_separators = '|',
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { { color = { bg = bg_color } } },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        tabline = {
          lualine_a = {},
          lualine_b = { { 'filename', file_status = true, path = 1 } },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },

  -- Noice UI improvements
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end,
  },
}
