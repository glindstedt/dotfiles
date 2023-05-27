-- {{{ Bootstrap packer.nvim
local packer_repo = "wbthomason/packer.nvim"

local packer_bootstrapped = nil
local function maybe_bootstrap_packer()
  local fn = vim.fn

  local packer_install_dir = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

  if fn.empty(fn.glob(packer_install_dir)) > 0 then
    vim.api.nvim_echo({
      { "Bootstrapping packer.nvim into ", "Type" },
      { packer_install_dir, "String" },
    }, true, {})

    -- https://github.com/wbthomason/packer.nvim/issues/750#issuecomment-1006070458
    vim.o.runtimepath = vim.fn.stdpath("data") .. "/site/pack/*/start/*," .. vim.o.runtimepath

    packer_bootstrapped = fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      string.format("https://github.com/%s", packer_repo),
      packer_install_dir,
    })
  end
end

maybe_bootstrap_packer()
-- }}}

return require("packer").startup(function(use)
  use(packer_repo)

  use("mg979/vim-visual-multi") -- Multiple cursor edit
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({})
    end,
  })
  use("tpope/vim-sleuth") -- Automatically detect indentation
  use("tpope/vim-unimpaired") -- Useful bindings

  -- Colorschemes
  use("EdenEast/nightfox.nvim")
  use("sainnhe/everforest")
  use("rebelot/kanagawa.nvim")
  use("catppuccin/nvim")
  -- UI
  use("nvim-lualine/lualine.nvim")
  use({
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
  })
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({})
    end,
  })
  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  })
  use({
    "romgrk/barbar.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
  })

  use("lukas-reineke/indent-blankline.nvim")
  use({
    "lewis6991/gitsigns.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })
  use("rcarriga/nvim-notify")
  use("norcalli/nvim-colorizer.lua")

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
    },
  })
  -- Use telescope for ui-select
  use("nvim-telescope/telescope-ui-select.nvim")
  use("akinsho/toggleterm.nvim")

  use({
    "ggandor/leap.nvim",
    requires = { "tpope/vim-repeat" },
  })
  use({
    "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("alpha.themes.theta").config)
    end,
  })

  -- Basic LSP stuff
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("neovim/nvim-lspconfig")
  use("lukas-reineke/lsp-format.nvim") -- format on save
  use({
    -- Nice LSP progress UI in bottom right corner
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  })

  -- Completion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
      "onsails/lspkind.nvim",
    },
  })
  use("hrsh7th/cmp-cmdline")

  -- Snippets library
  use("rafamadriz/friendly-snippets")
  -- Snippet engine
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("benfowler/telescope-luasnip.nvim")

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })

  -- LSP Bridge to CLI formatting/diagnostic tools
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })

  -- Language Support
  use("google/vim-jsonnet")

  use("Olical/conjure")
  use("PaterJason/cmp-conjure")

  use({
    "simrat39/rust-tools.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  })
  use({
    "saecki/crates.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
    end,
  })

  -- Debugging
  use({
    "rcarriga/nvim-dap-ui",
    requires = {
      "mfussenegger/nvim-dap",
    },
  })

  -- neorg
  use({
    "nvim-neorg/neorg",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",
    },
  })
  use({
    -- "~/Code/telescope-bookmarks.nvim",
    "dhruvmanila/telescope-bookmarks.nvim",
    -- Uncomment if the selected browser is Firefox or buku
    requires = {
      "tami5/sqlite.lua",
    },
  })
  use("stevearc/overseer.nvim")
  use({
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",

      -- Adapters
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
    },
  })
  use("eandrju/cellular-automaton.nvim")
  use("folke/neodev.nvim")
  use({
    "Pocco81/true-zen.nvim",
    config = function()
      require("true-zen").setup({
        integrations = {
          lualine = true,
        },
      })
    end,
  })
  use("folke/twilight.nvim")

  if packer_bootstrapped ~= nil then
    require("packer").sync()
  end
end)
