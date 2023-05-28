return {
  {
    "folke/zen-mode.nvim",
    dependencies = {
      { "folke/twilight.nvim", opts = {} },
    },
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
    opts = {
      plugins = {
        tmux = { enabled = true },
        alacritty = { enabled = true },
      },
    },
  },
}
