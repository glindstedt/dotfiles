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

-- Default tab expansion behaviour
local tabwidth = 4
vim.opt.tabstop = tabwidth
vim.opt.shiftwidth = tabwidth
vim.opt.softtabstop = -1 -- When negative the value of 'shiftwidth' is used
vim.opt.expandtab = true

-- Reduce timeout to make which-key more responsive
vim.opt.timeoutlen = 500

-- Automatically compile packer when saving plugins.lua
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("packer_user_config", {}),
  pattern = { "plugins.lua" },
  command = "source <afile> | PackerCompile",
})

-- Folding
-- Use treesitter as foldmethod
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldminlines = 20
