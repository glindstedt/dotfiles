local lspsaga_extension = {
  sections = {
    lualine_a = {
      function()
        return "Saga Outline"
      end,
    },
  },
  filetypes = { "sagaoutline" },
}
require("lualine").setup({
  extensions = {
    "neo-tree",
    "nvim-dap-ui",
    "overseer",
    "toggleterm",
    lspsaga_extension,
  },
})
