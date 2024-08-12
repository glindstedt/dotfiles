require("gitsigns").setup({
  on_attach = function(bufnr)
    local wk = require("which-key")
    wk.add({
      { "<leader>h", group = "Git" },
      { "<leader>hb", "<cmd>lua require('gitsigns').blame_line{full=true}<CR>", desc = "Blame line" },
      { "<leader>hp", "<cmd>lua require('gitsigns').preview_hunk()<CR>", desc = "Preview hunk" },
      { "<leader>hr", "<cmd>lua require('gitsigns').reset_hunk()<CR>", desc = "Reset hunk" },
      { "<leader>hs", "<cmd>lua require('gitsigns').stage_hunk()<CR>", desc = "Stage hunk" },
      { "<leader>hu", "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>", desc = "Undo stage hunk" },
      { "[c", "<cmd>lua require('gitsigns').prev_hunk()<CR>", desc = "Previous hunk" },
      { "]c", "<cmd>lua require('gitsigns').next_hunk()<CR>", desc = "Next hunk" },
      buffer = bufnr,
    })
  end,
})
