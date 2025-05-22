local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.completion.luasnip,
    null_ls.builtins.diagnostics.buildifier,
    null_ls.builtins.diagnostics.fish,
    null_ls.builtins.diagnostics.terraform_validate,
    null_ls.builtins.diagnostics.trail_space,
    null_ls.builtins.formatting.buildifier,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.formatting.just,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.hover.dictionary,
  },
  diagnostics_format = "[#{c}] #{m} (#{s})",
  on_attach = require("lib").lsp_on_attach,
})
