-- Editorconfig
-- https://github.com/editorconfig/editorconfig-vim#excluded-patterns
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*" }

-- Nightfox
local nightfox = require("nightfox")
nightfox.setup({
  fox = "nightfox",
})
nightfox.load()

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
    local function map(mode, lhs, rhs, opts)
      opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end
    -- TODO evaluate if this is the bindings I want
    map("n", "]c", '<cmd>lua require("gitsigns").next_hunk()<CR>')
    map("n", "[c", '<cmd>lua require("gitsigns").prev_hunk()<CR>')
    map("n", "<leader>hb", '<cmd>lua require("gitsigns").blame_line{full=true}<CR>')
    map("n", "<leader>hs", '<cmd>lua require("gitsigns").stage_hunk()<CR>')
    map("n", "<leader>hu", '<cmd>lua require("gitsigns").undo_stage_hunk()<CR>')
    map("n", "<leader>hp", '<cmd>lua require("gitsigns").preview_hunk()<CR>')
    map("n", "<leader>hr", '<cmd>lua require("gitsigns").reset_hunk()<CR>')
  end,
})

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

local nmap_opts = { noremap = true, silent = true }

-- LSP
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  --nmap_buf(bufnr, "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  --nmap_buf(bufnr, "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  --nmap_buf(bufnr, "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  --nmap_buf(bufnr, "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  --nmap_buf(bufnr, "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  --nmap_buf(bufnr, "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
  --nmap_buf(bufnr, "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
  --nmap_buf(bufnr, "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
  --nmap_buf(bufnr, "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  --nmap_buf(bufnr, "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  --nmap_buf(bufnr, "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  --nmap_buf(bufnr, "gr", "<cmd>lua vim.lsp.buf.references()<CR>")

  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", nmap_opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", nmap_opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", nmap_opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", nmap_opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", nmap_opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", nmap_opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", nmap_opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", nmap_opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>", nmap_opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", nmap_opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", nmap_opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", nmap_opts)
  -- TODO maybe replace `gr` with trouble entirely
  buf_set_keymap("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", nmap_opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<cr>", nmap_opts)

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

local lsp_common_settings = {
  on_attach = on_attach,
  flags = {
    -- This will be the default in neovim 0.7+
    debounce_text_changes = 150,
  },
}
local lspconfig = require("lspconfig")
-- rust-tools sets up the `rust_analyzer` lsp with the lsp settings under `server`
require("rust-tools").setup({
  server = lsp_common_settings,
})
-- Lua
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lspconfig["sumneko_lua"].setup({
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
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
  },
})

lspconfig["gopls"].setup({
  cmd = { "gopls", "-remote=auto" },
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
})

-- null-ls
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua, -- Lua
    null_ls.builtins.formatting.buildifier, -- Bazel
    null_ls.builtins.formatting.fish_indent, -- Fish

    null_ls.builtins.diagnostics.shellcheck, -- Bash
    null_ls.builtins.code_actions.shellcheck, -- Bash

    --null_ls.builtins.completion.spell,
  },
  diagnostics_format = "[#{c}] #{m} (#{s})",
  on_attach = on_attach,
})

-- nvim-cmp
local cmp = require("cmp")

cmp.setup({
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  --view = {
  --entries = { name = "wildmenu", separator = "|" },
  --entries = "native",
  --},
  experimental = {
    --native_menu = true,
    --ghost_text = true,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "luasnip" },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
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
          work = "~/notes/work",
          home = "~/notes/home",
        },
      },
    },
    ["core.norg.qol.toc"] = {},
    ["core.norg.concealer"] = {},
  },
})
