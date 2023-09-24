return {
  {
    -- allows folding by pressing `h` on first char of line
    "chrisgrieser/nvim-origami",
    event = "BufReadPost", -- later or on keypress would prevent saving folds
    opts = true,           -- needed even when using default config
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
      {
        -- statuscol overrides the default fold column to remove the level numbers
        -- also sets up click handlers for the folding column
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
              { text = { "%s" },                  click = "v:lua.ScSa" },
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
}
