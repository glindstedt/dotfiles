
local env = {}

function env.init(settings)
    -- This is used later as the default terminal and editor to run.
    local terminal = "urxvt" or "xterm"
    local editor = os.getenv("EDITOR") or "vim" or "vi"

    settings.env = {
        terminal = terminal,
        editor = editor,
        editor_cmd = terminal .. " -e " .. editor
    }
end

return env
