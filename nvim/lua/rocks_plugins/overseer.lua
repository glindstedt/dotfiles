require("overseer").setup({
  templates = {
    "builtin",
    "obazel",
  },
  task_list = {
    default_detail = 2,
    direction = "right",
  },
  form = {
      min_width = {120, 0.8},
  },
  log = {
    {
      type = "notify",
      level = vim.log.levels.DEBUG,
    },
  },
})
