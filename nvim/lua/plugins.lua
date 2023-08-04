return {
  "mg979/vim-visual-multi",

  { "numToStr/Comment.nvim", opts = {} },
  "tpope/vim-sleuth",
  { "tummetott/unimpaired.nvim", opts = {} },

  -- Libraries
  { "nvim-lua/plenary.nvim", lazy = true },
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
    opts = function()
      local default_config = require("neo-tree.defaults")
      -- don't steal from 'zz'
      default_config.window.mappings["z"] = nil
      default_config.window.mappings["Z"] = "close_all_nodes"
      return {
        --  NerdFonts 3 issues fix
        default_component_configs = {
          icon = {
            folder_empty = "󰜌",
            folder_empty_open = "󰜌",
          },
          git_status = {
            symbols = {
              renamed = "󰁕",
              unstaged = "󰄱",
            },
          },
        },
        document_symbols = {
          kinds = {
            File = { icon = "󰈙", hl = "Tag" },
            Namespace = { icon = "󰌗", hl = "Include" },
            Package = { icon = "󰏖", hl = "Label" },
            Class = { icon = "󰌗", hl = "Include" },
            Property = { icon = "󰆧", hl = "@property" },
            Enum = { icon = "󰒻", hl = "@number" },
            Function = { icon = "󰊕", hl = "Function" },
            String = { icon = "󰀬", hl = "String" },
            Number = { icon = "󰎠", hl = "Number" },
            Array = { icon = "󰅪", hl = "Type" },
            Object = { icon = "󰅩", hl = "Type" },
            Key = { icon = "󰌋", hl = "" },
            Struct = { icon = "󰌗", hl = "Type" },
            Operator = { icon = "󰆕", hl = "Operator" },
            TypeParameter = { icon = "󰊄", hl = "Type" },
            StaticMethod = { icon = "󰠄 ", hl = "Function" },
          },
        },
        use_default_mappings = false,
        window = {
          mappings = default_config.window.mappings,
        },
        filesystem = { window = { mappings = default_config.filesystem.window.mappings } },
        buffers = { window = { mappings = default_config.buffers.window.mappings } },
        git_status = { window = { mappings = default_config.git_status.window.mappings } },
      }
    end,
  },
  "folke/which-key.nvim",
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    config = function()
      require("hlchunk").setup({
        blank = { enable = false },
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
    dependencies = { "nvim-telescope/telescope.nvim" },
    init = function()
      require("telescope").load_extension("notify")
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
      {
        -- statuscol overrides the default fold column to remove the level numbers
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, condition = { true, builtin.not_empty }, click = "v:lua.ScLa" },
            },
          })
        end,
      },
    },
    config = function()
      local ufo = require("ufo")
      local promise = require("promise")

      local ftMap = {
        vim = "indent",
        python = "indent",
        git = "",
      }

      -- lsp -> treesitter -> indent
      local function customizeSelector(bufnr)
        local function handleFallbackException(err, providerName)
          if type(err) == "string" and err:match("UfoFallbackException") then
            return ufo.getFolds(providerName, bufnr)
          else
            return promise.reject(err)
          end
        end

        return ufo
          .getFolds("lsp", bufnr)
          :catch(function(err)
            return handleFallbackException(err, "treesitter")
          end)
          :catch(function(err)
            return handleFallbackException(err, "indent")
          end)
      end

      ufo.setup({
        provider_selector = function(_bufnr, filetype, _buftype)
          return ftMap[filetype] or customizeSelector
        end,
        preview = {
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            scrollE = "j",
            scrollY = "k",
          },
        },
      })
      vim.opt.foldcolumn = "1"
      vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true

      -- Remap so foldlevel is not modified
      vim.keymap.set("n", "zR", ufo.openAllFolds)
      vim.keymap.set("n", "zM", ufo.closeAllFolds)
      vim.keymap.set("n", "K", function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)
    end,
  },
  {
    "chrisgrieser/nvim-origami",
    event = "BufReadPost", -- later or on keypress would prevent saving folds
    opts = true, -- needed even when using default config
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
      screensaver = false,
    },
  },
  {
    "Olical/conjure",
    init = function()
      -- disable doc_word mapping to not conflict with K for lsp in rust
      vim.g["conjure#mapping#doc_word"] = false
    end,
  },
  {
    "Wansmer/treesj",
    keys = { "<space>m", "<space>j", "<space>s" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "giusgad/pets.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "edluffy/hologram.nvim" },
    opts = {
      row = 4,
      default_pet = "dog",
      default_style = "brown",
      random = false,
    },
  },
}
