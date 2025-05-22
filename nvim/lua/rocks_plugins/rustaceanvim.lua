vim.g.rustaceanvim = function()
  return {
    server = {
      on_attach = require("lib").lsp_on_attach,
      default_settings = {
        ["rust-analyzer"] = {
          cargo = {
            buildScripts = {
              enable = true,
            },
          },
        },
      },
    },
  }
end
-- vim.lsp.config("rust-analyzer", {
--   on_attach = require("lib").lsp_on_attach,
-- })
