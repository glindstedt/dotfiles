-- {{{ Bootstrap packer.nvim
local packer_repo = "wbthomason/packer.nvim"

local packer_bootstrapped = false
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
  use("preservim/nerdcommenter") -- Toggle commenting on lines
  use("tpope/vim-sleuth") -- Automatically detect indentation
  use("editorconfig/editorconfig-vim") -- Detect .editorconfig
  use("tpope/vim-unimpaired") -- Useful bindings

  -- UI
  use("EdenEast/nightfox.nvim")
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

  -- Basic LSP stuff
  use("neovim/nvim-lspconfig")
  use("williamboman/nvim-lsp-installer")

  -- Completion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/vim-vsnip",
      "neovim/nvim-lspconfig",
    },
  })

  -- Snippet engine
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")

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
  use("fatih/vim-go")

  use({
    "simrat39/rust-tools.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  })
  use({
    "saecki/crates.nvim",
    tag = "v0.1.0",
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
    -- tag = "latest", (see below)
    requires = "nvim-lua/plenary.nvim",
  })

  if packer_bootstrapped then
    require("packer").sync()
  end
end)
