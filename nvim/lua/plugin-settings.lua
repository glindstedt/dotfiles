-- Editorconfig
-- https://github.com/editorconfig/editorconfig-vim#excluded-patterns
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }

-- Nightfox
--local nightfox = require("nightfox")
--nightfox.setup({
--  fox = "nightfox",
--})
--nightfox.load()
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
  ensure_installed = "maintained",
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
    vim.cmd([[
        augroup LspFormatting
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
        augroup END
        ]])
  end
end

-- Configure servers installed by lsp-installer
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
require("nvim-lsp-installer").on_server_ready(function(server)
  local util = require("lspconfig.util")
  local opts = {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }

  if server.name == "rust_analyzer" then
    local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    require("rust-tools").setup({
      server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
      dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
      },
    })
    server:attach_buffers()
  else
    if server.name == "sumneko_lua" then
      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")
      opts.settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            path = runtime_path,
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      }
    end
    if server.name == "gopls" then
      opts.cmd = { "gopls", "-remote=auto" }
    end
    server:setup(opts)
  end
end)

-- null-ls
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.gitsigns,
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
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

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
  },
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
})

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

cmp.setup.cmdline("/", {
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
