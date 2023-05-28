local lsp_on_attach = function(client, bufnr)
  local wk = require("which-key")
  require("lsp-format").on_attach(client)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Buffer mappings
  wk.register({
    g = {
      name = "Go To",
      D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
      d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
      i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
      r = { "<cmd>TroubleToggle lsp_references<cr>", "Go to references" },
    },
    K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Open hover menu" },
    ["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" },
    ["<space>"] = {
      name = "LSP",
      w = {
        name = "Workspace",
        a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add workspace folder" },
        r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove workspace folder" },
        l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List workspace folders" },
      },
      D = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Definition" },
      rn = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      ca = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Actions" },
      F = { "<cmd>lua vim.lsp.buf.format({async=true})<cr>", "Format file" },
      f = {
        name = "Find",
        d = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "Symbols in Document" },
        w = { "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", "Symbols in Workspace" },
      },
    },
  }, {
    buffer = bufnr,
  })
end

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
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/which-key.nvim",
      "folke/trouble.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")
      return {
        sources = {
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.completion.luasnip,
          null_ls.builtins.diagnostics.buildifier,
          null_ls.builtins.diagnostics.fish,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.formatting.buildifier,
          null_ls.builtins.formatting.fish_indent,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.hover.dictionary,
        },
        diagnostics_format = "[#{c}] #{m} (#{s})",
        on_attach = lsp_on_attach,
      }
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    branch = "main",
    event = "LspAttach",
    opts = {},
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    -- Nice LSP progress UI in bottom right corner
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "lukas-reineke/lsp-format.nvim",
      "folke/which-key.nvim",
      "folke/trouble.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        on_attach = lsp_on_attach,
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
        },
      })
    end,
  },
}
