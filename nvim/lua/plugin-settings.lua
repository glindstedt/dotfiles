-- Editorconfig
-- https://github.com/editorconfig/editorconfig-vim#excluded-patterns
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }

-- Nightfox
vim.cmd("colorscheme nightfox")

-- Lualine
require("lualine").setup({
  options = {
    theme = "horizon",
  },
})

--nvim-tree
require("nvim-tree").setup({
  view = {
    width = 40,
  },
})
vim.g.nvim_tree_respect_buf_cwd = 1

require("indent_blankline").setup({
  show_current_context = true,
})
require("gitsigns").setup({
  on_attach = function(bufnr)
    local wk = require("which-key")
    wk.register({
      ["<leader>"] = {
        h = {
          name = "Gitsigns",
          b = { "<cmd>lua require('gitsigns').blame_line{full=true}<CR>", "Blame line" },
          s = { "<cmd>lua require('gitsigns').stage_hunk()<CR>", "Stage hunk" },
          u = { "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>", "Undo stage hunk" },
          p = { "<cmd>lua require('gitsigns').preview_hunk()<CR>", "Preview hunk" },
          r = { "<cmd>lua require('gitsigns').reset_hunk()<CR>", "Reset hunk" },
        },
      },
      ["]c"] = { "<cmd>lua require('gitsigns').next_hunk()<CR>", "Next hunk" },
      ["[c"] = { "<cmd>lua require('gitsigns').prev_hunk()<CR>", "Previous hunk" },
    }, {
      buffer = bufnr,
    })
  end,
})
require("colorizer").setup()

require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_cursor(),
    },
  },
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("luasnip")
require("telescope").load_extension("notify")

-- Get notifications via nvim-notify
vim.notify = require("notify")

require("toggleterm").setup({
  open_mapping = [[<c-\>]],
  direction = "float",
  float_opts = {
    border = "curved",
    winblend = 3,
  },
})

-- Treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
})
-- Use python parser for bzl files
local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
ft_to_parser.bzl = "python"

-- LSP
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Buffer mappings
  local wk = require("which-key")
  wk.register({
    g = {
      name = "Go To",
      D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
      d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
      i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
      -- r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Go to references" },
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
      f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format file" },
    },
  }, {
    buffer = bufnr,
  })

  -- Format on save
  if client.resolved_capabilities.document_formatting then
    local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = 0, group = group }) -- clear for current buffer only
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      buffer = 0,
      callback = vim.lsp.buf.formatting_seq_sync,
    })
  end
end

-- Configure servers installed by lsp-installer
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require("lspconfig")
lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  on_attach = on_attach,
  capabilities = capabilities,
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "bashls", "sumneko_lua" },
})
require("mason-lspconfig").setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup({})
  end,
  ["sumneko_lua"] = function()
    local lua_runtime_path = vim.split(package.path, ";")
    table.insert(lua_runtime_path, "lua/?.lua")
    table.insert(lua_runtime_path, "lua/?/init.lua")
    lspconfig.sumneko_lua.setup({
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
          gofumpt = true,
        },
      },
    })
  end,
  ["dockerls"] = function()
    -- Extend root pattern with .git
    lspconfig.dockerls.setup({
      root_dir = lspconfig.util.root_pattern("Dockerfile", ".git"),
    })
  end,
})

-- rust-tools
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

-- null-ls
local null_ls = require("null-ls")

null_ls.setup({
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
  on_attach = on_attach,
})

-- Debugging
require("dapui").setup()

-- nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-u>"] = cmp.mapping.scroll_docs(-8),
    ["<C-d>"] = cmp.mapping.scroll_docs(8),
    ["<C-Space>"] = cmp.mapping.complete({}),

    -- Integration with luasnip, use Tab/Shift-Tab to jump between snippet
    -- insert locations
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    -- Fallback to buffer
    { name = "buffer" },
  }),
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = {
    format = require("lspkind").cmp_format({
      mode = "symbol_text",
      menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        cmdline = "[CmdLine]",
      },
    }),
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

-- luasnip
require("luasnip.loaders.from_vscode").load()

-- Neorg
require("neorg").setup({
  load = {
    ["core.defaults"] = {},
    ["core.norg.dirman"] = {
      config = {
        autochdir = true,
        workspaces = {
          work = "~/Sync/notes/work",
          home = "~/Sync/notes/home",
        },
      },
    },
    ["core.norg.qol.toc"] = {},
    ["core.norg.concealer"] = {},
  },
})
