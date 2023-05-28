return {
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "folke/which-key.nvim",
    },
    opts = {
      on_attach = function(bufnr)
        local wk = require("which-key")
        wk.register({
          ["<leader>"] = {
            h = {
              name = "Git",
              b = { "<cmd>lua require('gitsigns').blame_line{full=true}<CR>", "Blame line" },
              s = { "<cmd>lua require('gitsigns').stage_hunk()<CR>", "Stage hunk" },
              u = { "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>", "Undo stage hunk" },
              p = { "<cmd>lua require('gitsigns').preview_hunk()<CR>", "Preview hunk" },
              r = { "<cmd>lua require('gitsigns').reset_hunk()<CR>", "Reset hunk" },
            },
          },
          ["]c"] = { "<cmd>lua require('gitsigns').next_hunk()<CR>", "Next hunk" },
          ["[c"] = { "<cmd>lua require('gitsigns').prev_hunk()<CR>", "Previous hunk" },
        }, {
          buffer = bufnr,
        })
      end,
    },
  },
}
