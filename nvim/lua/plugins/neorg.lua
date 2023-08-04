return {
  {
    "nvim-neorg/neorg",
    run = ":Neorg sync-parsers",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",
    },
    opts = {
      load = {
        -- Core
        ["core.defaults"] = {},
        ["core.esupports.metagen"] = {
          config = {
            type = "auto",
          },
        },
        ["core.keybinds"] = {
          config = {
            hook = function(keybinds)
              -- keybinds.map("norg", "n", "<localleader>ct", "<cmd>Neorg toggle-concealer<cr>")
              keybinds.map_event("norg", "n", "<C-CR>", "core.esupports.hop.hop-link vsplit")
              --keybinds.map_event("norg", "n", "<localleader>mi", "core.esupports.metagen inject-metadata")
              -- TODO
              keybinds.map_event("norg", "n", "<C-s>", "core.integrations.telescope.find_linkable")
              keybinds.map_event("norg", "i", "<C-l>", "core.integrations.telescope.insert_link")
            end,
          },
        },
        ["core.journal"] = {
          config = {
            journal_folder = "home/journal",
            workspace = "main",
          },
        },
        ["core.qol.toc"] = {},

        -- Extra
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.concealer"] = {
          config = {},
        },
        ["core.dirman"] = {
          config = {
            autochdir = true,
            workspaces = {
              main = "~/Sync/notes",
            },
            use_popup = false, -- use noice.nvim instead
            default_workspace = "main",
          },
        },
        ["core.summary"] = {},

        -- Community
        ["core.integrations.telescope"] = {},
      },
    },
  },
}
