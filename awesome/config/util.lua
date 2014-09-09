awful = require('awful')

local util = {}

-- Lengthens the shortest of the strings until they match in length
-- by appending or prepending spaces, depending on direction given.
function util.match_strlen(string1, string2, direction)

    local function _pend(string, length, pre)
        repeat
            if pre then
                string = " " .. string
            else
                string = string .. " "
            end
        until not (#string < length)
        return string
    end

    local max_length = math.max(#string1, #string2)
    local pre = (direction == "prepend" and true or false)

    if #string1 < max_length then
        string1 = _pend(string1, max_length, pre)
    else
        string2 = _pend(string2, max_length, pre)
    end

    return string1, string2
end

-- Run once function, so that restarting awesome doesn't start new instances
function util.run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end

  -- Fish shell
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " >/dev/null; or " .. cmd .. "")
  -- Bash shell
  --awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " >/dev/null || (" .. cmd .. ")")
end

-- Execute the array of commands, in order, using the run_once function
function util.autostart(commands)
    for _, command in ipairs(commands) do
        util.run_once(command)
    end
end

return util
