return {
  -- Treesitter: parsers + queries. On the `main` branch (the rewrite for
  -- Nvim 0.12+). The old `master` branch is frozen and breaks on 0.12
  -- (markdown injections crash with "attempt to call method 'range'").
  -- On main the plugin only installs parsers; highlighting is Neovim's own
  -- vim.treesitter.start(), switched on per buffer by the autocmd below.
  -- Parsers are compiled with the tree-sitter CLI (Brewfile) into
  -- stdpath('data')/site/parser. It must not be lazy-loaded.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.install({ "javascript", "python", "typescript", "c", "lua", "bash", "toml", "json", "markdown", "markdown_inline", "rust", "go", "gomod", "gosum" })

      -- Highlight every buffer whose language has a parser. A language
      -- nvim-treesitter knows but hasn't installed yet gets installed on
      -- first open (what master's auto_install did), then highlighted.
      local available = {}
      for _, lang in ipairs(ts.get_available()) do available[lang] = true end
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("aslan_treesitter", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then return end
          if pcall(vim.treesitter.start, args.buf, lang) then return end
          if not available[lang] then return end
          ts.install(lang):await(function()
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(args.buf) then
                pcall(vim.treesitter.start, args.buf, lang)
              end
            end)
          end)
        end,
      })
    end,
  },

  -- Treesitter context (show function/class context at top)
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3,
      })
    end,
  },

  -- Split/join code blocks
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "gs", "<cmd>lua require('treesj').toggle()<cr>", desc = "Split/join code" },
    },
    config = function()
      require('treesj').setup({})
    end,
  },

  -- Surround text objects
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },

  -- Docstring generation
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Neogen",
    config = function()
      require('neogen').setup({})
    end,
  },

  -- Vim tutorial game
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },
}
