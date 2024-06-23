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
  wk.register({
    g = {
      name = "Go To",
      h = { "<cmd>Lspsaga finder<cr>", "LSP finder" },
      d = { "<cmd>Lspsaga goto_definition<cr>", "Go to definition" },
      t = { "<cmd>Lspsaga goto_type_definition<cr>", "Go to type definition" },
      i = { "<cmd>Lspsaga finder imp<cr>", "Find implementations" },
      r = { "<cmd>Lspsaga finder ref<cr>", "Find references" },
      f = { "<cmd>Lspsaga finder def+ref+imp<cr>", "Find all..." },
    },
    -- nvim-ufo overrides this
    --K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Open hover doc" },
    ["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" },
    ["<space>"] = {
      name = "LSP",
      w = {
        name = "Workspace",
        a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add workspace folder" },
        r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove workspace folder" },
        l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List workspace folders" },
      },
      d = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" },
      t = { "<cmd>Lspsaga peek_type_definition<cr>", "Peek type definition" },
      ca = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Actions" },
      ci = { "<cmd>Lspsaga incoming_calls<cr>", "Incoming calls" },
      co = { "<cmd>Lspsaga outgoing_calls<cr>", "Outgoing calls" },
      o = { "<cmd>Lspsaga outline<cr>", "Open outline" },
      rn = { "<cmd>Lspsaga rename<cr>", "Rename in file" },
      rN = { "<cmd>Lspsaga rename ++project<cr>", "Rename in selected files" },
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
