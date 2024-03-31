vim.g.rustaceanvim = function()
  local dap_config = {}
  local codelldb_pkg = require("mason-registry").get_package("codelldb")
  if codelldb_pkg:is_installed() then
    local install_path = codelldb_pkg:get_install_path()
    local codelldb_path = install_path .. "/extension/adapter/codelldb"
    local liblldb_path = install_path .. "/extension/lldb/lib/liblldb.so"
    dap_config = {
      adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
    }
  end

  return {
    server = {
      on_attach = require("lib").lsp_on_attach,
    },
    dap = dap_config,
  }
end
