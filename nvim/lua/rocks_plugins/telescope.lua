require("telescope").setup({
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
})
require("telescope").load_extension("egrepify")
