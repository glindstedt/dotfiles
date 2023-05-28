return {
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = {
        "builtin",
        "user.bazel",
      },
      task_list = {
        default_detail = 2,
        direction = "right",
      },
      log = {
        {
          type = "notify",
          level = vim.log.levels.DEBUG,
        },
      },
    },
  },
}
