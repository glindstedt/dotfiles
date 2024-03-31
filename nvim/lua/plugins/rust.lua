return {
  {
    "saecki/crates.nvim",
    ft = "toml",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      src = {
        cmp = {
          enabled = true,
        },
      },
    },
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      local rust_tools_opts = {}
      local codelldb_pkg = require("mason-registry").get_package("codelldb")
      if codelldb_pkg:is_installed() then
        local install_path = codelldb_pkg:get_install_path()
        local codelldb_path = install_path .. "/extension/adapter/codelldb"
        local liblldb_path = install_path .. "/extension/lldb/lib/liblldb.so"
        rust_tools_opts = {
          dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        }
      end
      require("rust-tools").setup(rust_tools_opts)
    end,
  },
}
