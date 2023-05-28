return {
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "PaterJason/cmp-conjure",
    },

    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      return {
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-u>"] = cmp.mapping.scroll_docs(-8),
          ["<C-d>"] = cmp.mapping.scroll_docs(8),
          ["<C-Space>"] = cmp.mapping.complete({}),
          -- Integration with luasnip, use Tab/Shift-Tab to jump between snippet
          -- insert locations
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "neorg" },
          { name = "conjure" },
        }, {
          -- Fallback to buffer
          { name = "buffer" },
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol_text",
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              cmdline = "[CmdLine]",
              neorg = "[Neorg]",
              conjure = "[Conjure]",
            },
          }),
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
    end,
  },
}
