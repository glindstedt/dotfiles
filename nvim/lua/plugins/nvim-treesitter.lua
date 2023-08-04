return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.cue = {
        filetype = "cue",
        install_info = {
          url = "https://github.com/eonpatapon/tree-sitter-cue",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "main",
        },
      }
      parser_config.ron = {
        filetype = "ron",
        install_info = {
          url = "https://github.com/zee-editor/tree-sitter-ron",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "main",
        },
      }
      parser_config.river = {
        filetype = "river",
        install_info = {
          url = "https://github.com/grafana/tree-sitter-river",
          files = { "src/parser.c" },
          branch = "main",
        },
      }
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = {
          enable = true,
        },
      })
    end,
  },
}
