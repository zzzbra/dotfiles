return {
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'rafamadriz/friendly-snippets' },
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'nvim_lua' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = function(fallback)
            if luasnip.jumpable(1) then luasnip.jump(1) else fallback() end
          end,
          ['<C-b>'] = function(fallback)
            if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
          end,
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
      -- Apply nvim-cmp capabilities to all servers
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('*', { capabilities = capabilities })

      -- Lua LSP
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      })

      -- Python LSP
      vim.lsp.config('pyright', {
        settings = {
          python = {
            analysis = {
              autoImportCompletions = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "off",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = false,
        float = true,
      })
    end
  },

  -- Mason (LSP installer)
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    config = function()
      require('mason').setup()
    end,
  },

  -- Mason LSP config (v2+: uses vim.lsp.enable, requires Nvim 0.11+)
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = true,
    opts = {
      ensure_installed = {
        'ts_ls',
        'rust_analyzer',
        'pyright',
        'jsonls',
        'lua_ls',
      },
    },
  },

  -- None-ls (null-ls replacement)
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
        }
      })
    end,
  },
}
