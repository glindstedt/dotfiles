local default_config = require("neo-tree.defaults")
-- don't steal from 'zz'
default_config.window.mappings["z"] = nil
default_config.window.mappings["Z"] = "close_all_nodes"

require("neo-tree").setup({
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
})
