return {
  "mg979/vim-visual-multi",

  { "numToStr/Comment.nvim",       opts = {} },
  "tpope/vim-sleuth",
  "tpope/vim-unimpaired",

  -- Libraries
  { "nvim-lua/plenary.nvim",       lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Color Schemes
  {
    "catppuccin/nvim",
    init = function()
      vim.g.catppuccin_flavour = "macchiato"
      vim.cmd("colorscheme catppuccin")
    end,
  },
  "EdenEast/nightfox.nvim",
  "sainnhe/everforest",
  "rebelot/kanagawa.nvim",

  -- UI
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },
  "folke/which-key.nvim",
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = { show_current_context = true },
  },
  {
    "rcarriga/nvim-notify",
    dependencies = { "nvim-telescope/telescope.nvim" },
    init = function()
      -- TODO should I get noice.nvim?
      -- when noice is not enabled, install notify on VeryLazy
      -- local Util = require("lazyvim.util")
      -- if not Util.has("noice.nvim") then
      --   Util.on_very_lazy(function()
      vim.notify = require("notify")
      require("telescope").load_extension("notify")
      --   end)
      -- end
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    -- Red
    -- main = "colorizer",
    -- event = "VeryLazy",
    -- config = function()
    --   require('colorizer').setup()
    -- end
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = [[<c-\>]],
      direction = "float",
      float_opts = { border = "curved", winblend = 3 },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
  {
    "ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "goolord/alpha-nvim",
    opts = function()
      return require("alpha.themes.theta").config
    end,
  },
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {},
  },
  {
    "folke/drop.nvim",
    opts = {
      theme = "leaves",
      screensaver = 1000 * 60, -- show after 1 minute
    },
  },

  {
    "Olical/conjure",
    init = function()
      -- disable doc_word mapping to not conflict with K for lsp in rust
      vim.g["conjure#mapping#doc_word"] = false
    end,
  },
}
