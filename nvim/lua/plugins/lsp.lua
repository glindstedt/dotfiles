return {
  { "williamboman/mason.nvim", opts = {} },
  {
    "lukas-reineke/lsp-format.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      cpp = {
        -- stop clangd from auto formatting cpp files
        exclude = { "clangd" },
      },
      proto = {
        -- stop clangd from auto formatting proto files
        exclude = { "clangd" },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/which-key.nvim",
      "folke/trouble.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")
      return {
        sources = {
          null_ls.builtins.completion.luasnip,
          null_ls.builtins.diagnostics.buildifier,
          null_ls.builtins.diagnostics.fish,
          null_ls.builtins.formatting.buildifier,
          null_ls.builtins.formatting.fish_indent,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.hover.dictionary,
        },
        diagnostics_format = "[#{c}] #{m} (#{s})",
        on_attach = require("lib").lsp_on_attach,
      }
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    branch = "main",
    event = "LspAttach",
    opts = {
      finder = {
        keys = {
          toggle_or_open = "<CR>",
        },
      },
      lightbulb = {
        -- only show the virtual_text popup
        sign = false,
      },
    },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "folke/neodev.nvim",
        opts = {
          library = { plugins = { "nvim-dap-ui" }, types = true },
        },
      },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvimdev/lspsaga.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "lukas-reineke/lsp-format.nvim",
      "folke/which-key.nvim",
      "folke/trouble.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- nvim-ufo
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        on_attach = require("lib").lsp_on_attach,
        capabilities = capabilities,
      })
      require("mason-lspconfig").setup({
        ensure_installed = { "bashls", "lua_ls" },
        handlers = {
          -- The first entry (without a key) will be the default handler
          -- and will be called for each installed server that doesn't have
          -- a dedicated handler.
          function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup({})
          end,
          ["lua_ls"] = function()
            local lua_runtime_path = vim.split(package.path, ";", {})
            table.insert(lua_runtime_path, "lua/?.lua")
            table.insert(lua_runtime_path, "lua/?/init.lua")
            lspconfig.lua_ls.setup({
              settings = {
                Lua = {
                  runtime = {
                    version = "LuaJIT",
                    path = lua_runtime_path,
                  },
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    -- https://github.com/LuaLS/lua-language-server/issues/679
                    checkThirdParty = false,
                  },
                },
              },
            })
          end,
          ["gopls"] = function()
            lspconfig.gopls.setup({
              cmd = { "gopls", "-remote=auto" },
              settings = {
                gopls = {
                  directoryFilters = {
                    "-**/bazel-bin",
                    "-**/bazel-out",
                    "-**/bazel-src",
                    "-**/bazel-testlogs",
                    "-**/node_modules",
                    "-bazel-bin",
                    "-bazel-out",
                    "-bazel-src",
                    "-bazel-testlogs",
                    "-node_modules",
                  },
                  gofumpt = true,
                },
              },
            })
          end,
          ["dockerls"] = function()
            -- Extend root pattern with .git
            lspconfig.dockerls.setup({
              root_dir = lspconfig.util.root_pattern("Dockerfile", ".git"),
              settings = {
                docker = {
                  languageserver = {
                    formatter = {
                      ignoreMultilineInstructions = true,
                    },
                  },
                },
              },
            })
          end,
          ["clangd"] = function()
            lspconfig.clangd.setup({
              -- remove proto, let bufls handle that
              filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
            })
          end,
          ["helm_ls"] = function()
            lspconfig.helm_ls.setup({
              cmd = { "helm_ls", "serve" },
              filetypes = { "helm" },
              root_dir = lspconfig.util.root_pattern("Chart.yaml"),
            })
          end,
          -- TODO can I get yamlls to not attach if helm_ls attached?
          -- ["yamlls"] = function()
          --   lspconfig.yamlls.setup({
          --     on_init = function(client)
          --       vim.print(client)
          --     end,
          --     -- filetypes = vim.tbl_filter(function(ft)
          --     --   return not vim.tbl_contains({ "helm" }, ft)
          --     -- end, lspconfig.yamlls.document_config.default_config.filetypes),
          --   })
          -- end,
        },
      })
    end,
  },
}
