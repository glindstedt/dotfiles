return { {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "nvim-telescope/telescope.nvim",
    "benfowler/telescope-luasnip.nvim",
  },
  init = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("telescope").load_extension('luasnip')
  end
} }
