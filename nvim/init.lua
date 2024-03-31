require("settings")

-- Switch between lazy.nvim and rocks.nvim for plugin management via env variable
local plugin_managers = { "lazy", "rocks" }
local plugin_manager = vim.env.NVIM_PLUG_MANAGER or "lazy"

if not vim.list_contains(plugin_managers, plugin_manager) then
  plugin_manager = "lazy"
end

if plugin_manager == "lazy" then
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup("plugins")
end

if plugin_manager == "rocks" then
  -- {{{ rocks.nvim
  local rocks_config = {
    rocks_path = vim.fn.stdpath("data") .. "/rocks",
    luarocks_binary = vim.fn.stdpath("data") .. "/rocks/bin/luarocks",
  }

  vim.g.rocks_nvim = rocks_config

  local luarocks_path = {
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
  }
  package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

  local luarocks_cpath = {
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
  }
  package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

  vim.opt.runtimepath:append(
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*")
  )
  -- }}}

  -- Eager load of colorscheme so we can set it here
  require("rocks").packadd("kanagawa.nvim")
  vim.cmd("colorscheme kanagawa")
end

print(vim.env.NVIM_PLUG_MANAGER)
-- vim.api.nvim_notify(vim.env.NVIM_PLUG_MANAGER, 0, {})
require("mappings")
