return {
  {
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",
    },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
          config = {
            autochdir = true,
            workspaces = {
              work = "~/Sync/notes/work",
              home = "~/Sync/notes/home",
            },
          },
        },
        ["core.qol.toc"] = {},
        ["core.concealer"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.journal"] = {
          config = {
            workspace = "home",
          },
        },
        ["core.integrations.telescope"] = {},
        ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
        ["core.keybinds"] = {
          config = {
            hook = function(keybinds)
              keybinds.map("norg", "n", "<localleader>ct", "<cmd>Neorg toggle-concealer<cr>")
              keybinds.map_event("norg", "n", "<C-s>", "core.integrations.telescope.find_linkable")
              keybinds.map_event("norg", "i", "<C-l>", "core.integrations.telescope.insert_link")
            end,
          },
        },
      },
    },
  },
}
