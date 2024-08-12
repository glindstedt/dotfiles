local lib = {}

---@param client vim.lsp.Client
---@param bufnr integer
---@see vim.lsp.Client
lib.lsp_on_attach = function(client, bufnr)
  local wk = require("which-key")
  require("lsp-format").on_attach(client)
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", {
    buf = bufnr,
  })

  if client.name == "yamlls" then
    -- yaml-language-server has this capability but doesn't advertise it
    client.server_capabilities.documentFormattingProvider = true
  end

  -- Buffer mappings
  wk.add({
    { "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature help" },
    { "<space>", group = "LSP" },
    { "<space>F", "<cmd>lua vim.lsp.buf.format({async=true})<cr>", desc = "Format file" },
    { "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Actions" },
    { "<space>ci", "<cmd>Lspsaga incoming_calls<cr>", desc = "Incoming calls" },
    { "<space>co", "<cmd>Lspsaga outgoing_calls<cr>", desc = "Outgoing calls" },
    { "<space>d", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
    { "<space>f", group = "Find" },
    { "<space>fd", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", desc = "Symbols in Document" },
    {
      "<space>fw",
      "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>",
      desc = "Symbols in Workspace",
    },
    { "<space>o", "<cmd>Lspsaga outline<cr>", desc = "Open outline" },
    { "<space>rN", "<cmd>Lspsaga rename ++project<cr>", desc = "Rename in selected files" },
    { "<space>rn", "<cmd>Lspsaga rename<cr>", desc = "Rename in file" },
    { "<space>t", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek type definition" },
    { "<space>w", group = "Workspace" },
    { "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", desc = "Add workspace folder" },
    {
      "<space>wl",
      "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
      desc = "List workspace folders",
    },
    { "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", desc = "Remove workspace folder" },
    { "g", group = "Go To" },
    { "gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Go to definition" },
    { "gf", "<cmd>Lspsaga finder def+ref+imp<cr>", desc = "Find all..." },
    { "gh", "<cmd>Lspsaga finder<cr>", desc = "LSP finder" },
    { "gi", "<cmd>Lspsaga finder imp<cr>", desc = "Find implementations" },
    { "gr", "<cmd>Lspsaga finder ref<cr>", desc = "Find references" },
    { "gt", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Go to type definition" },
    buffer = bufnr,
  })
end

local setup_blobs = {}

-- nvim-ufo stuff
local ufoFtMap = {
  vim = "indent",
  python = "indent",
  git = "",
}

-- lsp -> treesitter -> indent
local function customizeSelector(bufnr, _filetype, _buftype)
  local ufo = require("ufo")
  local promise = require("promise")

  local function handleFallbackException(err, providerName)
    if type(err) == "string" and err:match("UfoFallbackException") then
      return ufo.getFolds(providerName, bufnr)
    else
      return promise.reject(err)
    end
  end

  return ufo
    .getFolds("lsp", bufnr)
    :catch(function(err)
      return handleFallbackException(err, "treesitter")
    end)
    :catch(function(err)
      return handleFallbackException(err, "indent")
    end)
end

setup_blobs.ufo = {
  provider_selector = function(_bufnr, filetype, _buftype)
    return ufoFtMap[filetype] or customizeSelector
  end,
  preview = {
    mappings = {
      scrollU = "<C-u>",
      scrollD = "<C-d>",
      scrollE = "j",
      scrollY = "k",
    },
  },
}

lib.setup = setup_blobs

return lib
