return {
  -- Diffview for git diffs
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
    },
  },
}
