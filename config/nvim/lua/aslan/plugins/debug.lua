return {
  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-telescope/telescope-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle breakpoint" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Breakpoint icons
      local dap_breakpoint = {
        error = {
          text = "🟥",
          texthl = "LspDiagnosticsSignError",
          linehl = "",
          numhl = "",
        },
        rejected = {
          text = "",
          texthl = "LspDiagnosticsSignHint",
          linehl = "",
          numhl = "",
        },
        stopped = {
          text = "⭐️",
          texthl = "LspDiagnosticsSignInformation",
          linehl = "DiagnosticUnderlineInfo",
          numhl = "LspDiagnosticsSignInformation",
        },
      }

      vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
      vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
      vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

      -- Virtual text setup
      require("nvim-dap-virtual-text").setup({
        commented = true,
      })

      -- DAP UI setup
      dapui.setup({})

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Dart adapter (will use flutter from PATH if available)
      -- Uncomment and update if Flutter is not in your PATH:
      -- dap.adapters.dart = {
      --   type = "executable",
      --   command = "/path/to/flutter/bin/flutter",
      --   args = { "debug_adapter" }
      -- }

      dap.configurations = {
        dart = {
          type = "dart",
          request = "launch",
          name = "Launch Dart Program",
          program = "${file}",
          cwd = "${workspaceFolder}",
          args = { "--help" },
        }
      }
    end,
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
  },

  -- DAP Virtual Text
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
  },

  -- Telescope DAP integration
  {
    "nvim-telescope/telescope-dap.nvim",
    lazy = true,
  },
}
