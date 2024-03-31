-- return {
--   name = "Bazel build ...",
--   builder = function(params)
--     local target = params.target
--     return {
--       cmd = { "bazel" },
--       args = { "build", target },
--       name = "bazel build " .. target,
--     }
--   end,
--   desc = "Build custom target",
--   params = {
--     target = {
--       type = "string",
--       name = "Target",
--       desc = "Bazel target",
--     },
--   },
--   condition = {
--     dir = { "/home/glindstedt/Code/src" },
--   },
-- }

---@module 'overseer'

local Job = require("plenary.job")
local overseer = require("overseer")
local log = require("overseer.log")
local constants = require("overseer.constants")
local TAG = constants.TAG

local function debug(str)
  vim.api.nvim_notify(str, 1, {})
end

---@type overseer.TemplateDefinition
local tmpl = {
  priority = 50,
  params = {
    args = { type = "list", delimiter = " " },
  },
  builder = function(params)
    return {
      cmd = { "bazel" },
      args = params.args,
    }
  end,
}

local function get_workspace(opts)
  local workspace_file
  local parent_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  workspace_file = vim.fn.findfile("WORKSPACE", parent_dir .. ";")
  if workspace_file == "" then
    return nil
  end
  return vim.fn.fnamemodify(workspace_file, ":p:h")
end

---@param opts overseer.SearchParams
---@return nil|string
local function get_buildfile(opts)
  local buildfile

  local parent_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")

  buildfile = vim.fn.findfile("BUILD.bazel", parent_dir .. ";")
  debug(string.format("found build file '%s'", buildfile))

  if buildfile == "" then
    return nil
  end
  return vim.fn.fnamemodify(buildfile, ":p")
end

---@param workspace nil|string
---@param buildfile nil|string
---@return nil|string
local function buildfile_target_prefix(workspace, buildfile)
  if workspace == nil or buildfile == nil then
    return nil
  end
  local relpath = vim.fn.fnamemodify(buildfile, string.format(":s?%s/??:h", workspace))
  debug(relpath)
  return "//" .. relpath
end

---@param query string
---@return string[]
local function bazel_query(query)
  debug("bazel query " .. query)
  local targets = {}
  local job = Job:new({
    command = "bazel",
    args = { "query", query },
    on_stdout = function(_, line)
      if string.match(line, "//.*") then
        table.insert(targets, line)
      end
    end,
  })
  job:sync()
  debug(vim.inspect(job:result()))
  -- job:sync()
  -- debug("results")
  -- debug(vim.inspect(job:result()))
  -- debug("targets")
  -- debug(vim.inspect(targets))
  -- local jid = vim.fn.jobstart({ "bazel", "query", query }, {
  --   stdout_buffered = true,
  --   on_stdout = vim.schedule_wrap(function(j, output)
  --     debug(vim.inspect(output))
  --     for _, line in ipairs(output) do
  --       if string.match(line, "//.*") then
  --         table.insert(targets, line)
  --       end
  --     end
  --     debug("stdout received " .. table.getn(targets))
  --     -- cb(targets)
  --   end),
  --   on_exit = function()
  --     debug("exited")
  --   end,
  -- })
  -- -- TODO error handling?
  -- if jid == 0 then
  --   log:error("invalid arguments")
  -- elseif jid == -1 then
  --   log:error("bazel not executable")
  -- end
  -- debug("waiting for jid " .. jid)
  -- vim.fn.jobwait({ jid })
  -- debug("returning from bazel query " .. table.getn(targets))
  return targets
end

---@param prefix string
---@param type string
---@return string
local function target_query(prefix, type)
  local query
  if type == "build" then
    query = "'" .. prefix .. "/...'"
  elseif type == "run" then
    query = '\'kind(".*_binary", ' .. prefix .. "/...)'"
  elseif type == "test" then
    query = "'tests(" .. prefix .. "/...)'"
  end
  return query
end

local function gather_targets(prefix, cb)
  -- Default templates
  local templates = {
    overseer.wrap_template(tmpl, { name = "bazel ...", priority = 60 }, {}),
    overseer.wrap_template(tmpl, { name = "bazel run //:gazelle", priority = 60 }, { args = { "run", "//:gazelle" } }),
  }

  for _, command in ipairs({
    { type = "build", tags = { TAG.BUILD } },
    { type = "test", tags = { TAG.TEST } }, -- TODO FIND OUT WHY THIS AIN'T WORKING
    { type = "run" },
  }) do
    local targets = bazel_query(target_query(prefix, command.type))
    debug(vim.inspect(targets))
    for _, target in ipairs(targets) do
      debug(command.type .. " target: " .. target)
      table.insert(
        templates,
        overseer.wrap_template(
          tmpl,
          { name = string.format("bazel %s %s", command.type, target), tags = command.tags },
          { args = { command.type, target } }
        )
      )
    end
    -- debug(vim.inspect(templates))
    -- cb(templates)
  end
  debug("returning from gather_targets " .. table.getn(templates))
  cb(templates)
end

---@type overseer.TemplateProvider
return {
  cache_key = function(opts)
    local cache_key = get_buildfile(opts)
    local workspace = get_workspace(opts)
    -- local target_prefix = buildfile_target_prefix(workspace, cache_key)
    debug(string.format("found workspace dir '%s'", workspace))
    debug(string.format("found cache key '%s'", cache_key))
    debug(buildfile_target_prefix(workspace, cache_key))
    -- bazel_query(target_prefix, "build")
    return cache_key
  end,
  condition = {
    callback = function(opts)
      if vim.fn.executable("bazel") == 0 then
        return false, "Command 'bazel' not found"
      end
      if not get_buildfile(opts) then
        return false, "No BUILD.bazel file found"
      end
      return true
    end,
  },
  generator = function(opts, cb)
    local workspace = get_workspace(opts)
    local buildfile = get_buildfile(opts)
    local target_prefix = buildfile_target_prefix(workspace, buildfile)

    gather_targets(target_prefix, cb)
  end,
}
