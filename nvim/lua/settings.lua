vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

---@module 'obazel'
---@type obazel.Config
vim.g.obazel = {
  -- TODO try out putting this in a .nvim.lua
  -- bazel_binary = "foobar",
  -- blabla="foobar"
  overseer = {
    templates = {
      { template = { name = "bazel ...", priority = 49 } },
      {
        template = { name = "bazel run //:gazelle", priority = 50 },
        args = { "run", "//:gazelle" },
      },
    },
    generators = {
      {
        query_template = "tests(%s:*)",
        args = { "test" },
        template_file_definition = {
          tags = { "TEST" },
          priority = 51,
        },
      },
      {
        query_template = 'kind(".*_binary", %s:*)',
        args = { "run" },
        template_file_definition = {
          tags = { "RUN" },
          priority = 52,
        },
      },
      {
        query_template = "kind(rule, %s:*)",
        args = { "build" },
        template_file_definition = {
          tags = { "BUILD" },
          priority = 100,
        },
      },
    },
  },
}

vim.opt.exrc = true

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
  virtual_lines = true,
  -- virtual_text = true,
}

vim.treesitter.language.register("terraform", { "terraform", "terraform-vars" })

vim.diagnostic.config(config)
