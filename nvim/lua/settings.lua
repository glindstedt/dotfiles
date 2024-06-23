vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

vim.opt.encoding = "utf-8"
vim.opt.backspace = "indent,eol,start"

-- Set characters for displaying whitespace
vim.opt.listchars = { tab = ">-", trail = "·", eol = "$" }

-- Enable mouse support
vim.opt.mouse = "a"

-- Ignore case by default when searching
vim.opt.ignorecase = true
-- Override ignorecase if search contains upper case characters
vim.opt.smartcase = true

-- Open vertical splits to the right
vim.opt.splitright = true

-- Default to conceallevel 2
vim.opt.conceallevel = 2

-- Default tab expansion behaviour
local tabwidth = 4
vim.opt.tabstop = tabwidth
vim.opt.shiftwidth = tabwidth
vim.opt.softtabstop = -1 -- When negative the value of 'shiftwidth' is used
vim.opt.expandtab = true

-- Reduce timeout to make which-key more responsive
vim.opt.timeoutlen = 500

-- Folding
vim.opt.foldminlines = 20

-- Use python parser for bzl files
-- vim.treesitter.language.register("python", "bzl")

-- Configuration for diagnostics
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
  signs = {
    active = signs, -- show signs
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "single",
    source = "always",
    header = "Diagnostic",
    prefix = "",
  },
}

vim.diagnostic.config(config)
