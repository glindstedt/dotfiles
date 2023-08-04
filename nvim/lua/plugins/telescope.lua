return {
  {
    "fdschmidt93/telescope-egrepify.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    opts = function()
      local telescope_themes = require("telescope.themes")
      return {
        defaults = {
          prompt_prefix = "🔍",
          mappings = {
            i = {
              ["<C-Down>"] = function(...)
                require("telescope.actions").cycle_history_next(...)
              end,
              ["<C-Up>"] = function(...)
                require("telescope.actions").cycle_history_prev(...)
              end,
            },
          },
        },
        extensions = {
          ["ui-select"] = { telescope_themes.get_cursor() },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("egrepify")
    end,
  },
}
