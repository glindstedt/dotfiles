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

--
-- vim.cmd("highlight ColorColumn ctermbg=darkgrey")

-- TODO evaluate if this is what I want
-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
--vim.o.completeopt = "menuone,noinsert,noselect"
--vim.o.completeopt = "menu,menuone,noselect"

-- Automatically compile packer when saving plugins.lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Folding
-- Use treesitter as foldmethod
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
--vim.opt.foldlevel = 1
vim.opt.foldminlines = 20

-- Detect dockerfile for treesitter
vim.cmd([[
  augroup filetype_docker
    autocmd!
    autocmd BufRead,BufNewFile [Dd]ockerfile set filetype=dockerfile
    autocmd BufRead,BufNewFile [Dd]ockerfile* set filetype=dockerfile
    autocmd BufRead,BufNewFile *.[Dd]ockerfile set filetype=dockerfile
  augroup end
]])
