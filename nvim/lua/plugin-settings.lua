-- Editorconfig
-- https://github.com/editorconfig/editorconfig-vim#excluded-patterns
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }

-- Colorschemes
-- vim.cmd("colorscheme nightfox")
-- vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme everforest")
vim.g.catppuccin_flavour = "macchiato"
vim.cmd("colorscheme catppuccin")

-- Lualine
require("lualine").setup({
  sections = {
    lualine_x = { "overseer" },
  },
})

--nvim-tree
local nt_api = require("nvim-tree.api")

local on_attach_nvim_tree = function(bufnr)
  nt_api.config.mappings.default_on_attach(bufnr)
  vim.keymap.del("n", "<C-e>", { buffer = bufnr })
end

require("nvim-tree").setup({
  view = {
    width = 40,
  },
  on_attach = on_attach_nvim_tree,
})
vim.g.nvim_tree_respect_buf_cwd = 1

-- barbar <-> nvim-tree
local bl_api = require("bufferline.api")
nt_api.events.subscribe(nt_api.events.Event.TreeOpen, function()
  bl_api.set_offset(require("nvim-tree.view").View.width)
end)
nt_api.events.subscribe(nt_api.events.Event.Resize, function(size)
  bl_api.set_offset(size)
end)
nt_api.events.subscribe(nt_api.events.Event.TreeClose, function()
  bl_api.set_offset(0)
end)

require("indent_blankline").setup({
  show_current_context = true,
})
require("colorizer").setup()

require("telescope").setup({
  defaults = {
    prompt_prefix = "🔍",
    mappings = {
      i = {
        ["<C-Down>"] = require("telescope.actions").cycle_history_next,
        ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_cursor(),
    },
    ["bookmarks"] = {
      selected_browser = "firefox",
      firefox_profile_name = "default-release",
    },
  },
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("luasnip")
require("telescope").load_extension("notify")
require("telescope").load_extension("bookmarks")

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
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    h = {
      name = "Git",
      l = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "lazygit" },
    },
  },
})

require("gitsigns").setup({
  on_attach = function(bufnr)
    wk.register({
      ["<leader>"] = {
        h = {
          name = "Git",
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

-- set comment string for cue filetype
require("Comment.ft").set("cue", "//%s")

require("leap").add_default_mappings()

-- Treesitter
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.cue = {
  filetype = "cue",
  install_info = {
    url = "https://github.com/eonpatapon/tree-sitter-cue",
    files = { "src/parser.c", "src/scanner.c" },
    branch = "main",
  },
}
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
})
-- Use python parser for bzl files
local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
ft_to_parser.bzl = "python"

local lsp_format = require("lsp-format")
lsp_format.setup({
  cpp = {
    -- stop clangd from auto formatting cpp files
    exclude = { "clangd" },
  },
  proto = {
    -- stop clangd from auto formatting proto files
    exclude = { "clangd" },
  },
})

-- LSP
local on_attach = function(client, bufnr)
  lsp_format.on_attach(client)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Buffer mappings
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

-- IMPORTANT must be before lsp config
require("neodev").setup({})

-- Configure servers installed by lsp-installer
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  on_attach = on_attach,
  capabilities = capabilities,
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "bashls", "lua_ls" },
})
require("mason-lspconfig").setup_handlers({
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

-- overseer
local overseer = require("overseer")
overseer.setup({
  templates = {
    "builtin",
  },
  task_list = {
    default_detail = 2,
    direction = "right",
  },
  log = {
    {
      type = "notify",
      level = vim.log.levels.DEBUG,
    },
  },
})

-- neotest
require("neotest").setup({
  adapters = {
    require("neotest-go"),
    require("neotest-rust"),
  },
  consumers = {
    overseer = require("neotest.consumers.overseer"),
  },
})

-- conjure
-- disable doc_word mapping to not conflict with K for lsp in rust
vim.g["conjure#mapping#doc_word"] = false

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
    { name = "neorg" },
    { name = "conjure" },
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
        neorg = "[Neorg]",
        conjure = "[Conjure]",
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
})
