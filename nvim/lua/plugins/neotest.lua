return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",

      -- Adapters
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-plenary",
      "rouge8/neotest-rust",
      -- Consumers
      "stevearc/overseer.nvim",
    },

    opts = function()
      return {
        adapters = {
          require("neotest-go"),
          require("neotest-rust"),
          require("neotest-plenary"),
        },
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
      }
    end,
  },
}
