return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",

      -- Adapters
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
      -- Consumers
      "stevearc/overseer.nvim",
    },

    opts = function()
      local adapter_go = require("neotest-go")
      local adapter_rust = require("neotest-rust")
      local overseer_consumer = require("neotest.consumers.overseer")
      return {
        adapters = {
          adapter_go,
          adapter_rust,
        },
        consumers = {
          overseer = overseer_consumer,
        },
      }
    end,
  },
}
