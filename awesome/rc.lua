local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
require("awful.autofocus")

local config = require("config")

-- {{{ Settings table
local terminal = "urxvt"
local editor = os.getenv("EDITOR") or "vim"

local settings = {
    theme_dir = os.getenv("HOME") .. "/.config/awesome/theme/theme.lua",
    modkey = "Mod4",
    terminal = terminal,
    editor = editor,
    editor_cmd = terminal .. " -e " .. editor
}
-- }}}


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Theme
beautiful.init("/home/glindste/.config/awesome/theme/theme.lua")
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

--- {{{ Models (Sort of...)
config.layouts.init(settings)

config.launcher.init(settings)

config.widgets.init(settings)

--- }}}

--- {{{ Controllers (Sort of...)
config.toolbar.init(settings) -- depends: launcher.init

config.keybinds.init(settings)

config.rules.init(settings) -- depends: keybinds.init

config.signals.init(settings)
--- }}}

-- {{{ Autostart

config.util.autostart({
    "wicd-client --tray",
    "radiotray"
})

---- }}}

-- vim: syntax=lua
