-- neodev needs to be initialized before lsp
require("neodev").setup({})
-- Mason needs to be initialized before mason-lspconfig is used
require("mason").setup({})

require("lspsaga").setup({
  finder = {
    keys = {
      toggle_or_open = "<CR>",
    },
  },
  lightbulb = {
    sign = false,
  },
})

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

lspconfig.starpls.setup({})

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
            format = {
              -- Let stylua do the formatting via null-ls
              enable = false,
            },
            runtime = {
              version = "LuaJIT",
              path = lua_runtime_path,
            },
            diagnostics = {
              globals = { "vim" },
              -- Ignore unused locals that starts with underscores
              unusedLocalExclude = { "_*" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              -- https://github.com/LuaLS/lua-language-server/issues/679
              checkThirdParty = false,
            },
            hint = {
              enable = true,
            },
          },
        },
      })
    end,
    ["gopls"] = function()
      lspconfig.gopls.setup({
        on_init = function(client)
          local path = client.workspace_folders[1].name
          local is_bazel_workspace = vim.fn.filereadable(path .. "/WORKSPACE")
          if is_bazel_workspace ~= 0 then
            client.settings["gopls"].env.GOPACKAGESDRIVER = path .. "/bazel/gopackagesdriver.sh"
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
        end,
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
            hints = {
              compositeLiteralFields = true,
              -- compositeLiteralTypes = true,
              constantValues = true,
              parameterNames = true,
              -- assignVariableTypes = true,
              -- rangeVariableTypes = true,
              functionTypeParameters = true,
            },
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
    ["rust_analyzer"] = function()
      -- Disable so it doesn't conflict with rustaceanvim plugin
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
