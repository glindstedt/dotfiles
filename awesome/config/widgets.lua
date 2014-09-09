local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local lain = require("lain")
local beautiful = require("beautiful")

local util = require("config.util")
local colors = require("config.colors")

local widgets = {}

local markup = lain.util.markup

function widgets.init(settings)

    -- Space
    local space = wibox.widget.textbox()
    space:set_text(" ")

    -- Separator
    local separator = wibox.widget.textbox()
    separator:set_markup(markup(colors.grey, "|"))

    -- Create a textclock widget
    local textclock = awful.widget.textclock()

    -- Battery widget
    local batwidget = lain.widgets.bat({
        settings = function ()
            local bat_header = "⚡"
            local bat_p = bat_now.perc

            if bat_now.status == "Not present" then
                bat_header = ""
                bat_p = ""
            elseif bat_now.status == "Discharging" then
                bat_p = markup(colors.yellow, bat_p)
            else
                bat_p = markup(colors.green, bat_p)
            end

            widget:set_markup(markup(colors.yellow, bat_header) .. bat_p)
        end
    })

    -- Memory widget
    local show_mem_info = function ()

        local rused = tostring(mem_now.used)
        local sused = tostring(mem_now.swapused)

        -- Prepend spaces so string lengths match
        rused, sused = util.match_strlen(rused, sused, "prepend")

        local string = markup(colors.green, rused) .. " MB ram used\n"
        string = string .. markup(colors.yellow, sused) .. " MB swap used"
        notification = naughty.notify({
            text = string,
            timeout = 0
        })
    end
    local hide_mem_info = function ()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end
    local memory = lain.widgets.mem({
        settings = function ()
            local mused = markup(colors.green, mem_now.used .. "MB")
            local sused = markup(colors.yellow, mem_now.swapused)

            widget:set_markup("(" .. mused .. markup(colors.magenta,"|") .. sused .. ")")
            widget:connect_signal('mouse::enter', show_mem_info)
            widget:connect_signal('mouse::leave', hide_mem_info)
        end
    })

    -- CPU widget
    local cpuwidget = lain.widgets.cpu({
        settings = function ()
            widget:set_markup(markup(colors.cyan, cpu_now.usage .. "%"))
        end
    })

    -- Disk usage of root
    local root_disk_usage = lain.widgets.fs({
        settings = function ()
            local used = markup(colors.red,fs_now.used .. "% Used")
            widget:set_markup(used)
        end
    })

    -- Network traffic
    local net = lain.widgets.net({
        settings = function ()
            local up = "U " ..  markup(colors.green, net_now.sent)
            local down = "D " .. markup(colors.blue, net_now.received)
            local state = markup(colors.grey, net_now.state)
            widget:set_markup(up .. " " .. down)
        end
    })

    -- System load
    local sysload = lain.widgets.sysload({
        settings = function ()
            widget:set_markup(markup(colors.yellow, load_1 .. " " .. load_5 .. " " .. load_15))
        end
    })

    -- Volume widget
    local volwidget = lain.widgets.alsa({
        settings = function ()
            local string = volume_now.level .. "♬"
            if volume_now.status == "off" then
                string = markup(colors.red, string)
            end
            widget:set_markup(string)
        end
    })

    --{{ MPD widget
    -- Popup
    local show_mpd_info = function ()
        local string = markup(colors.green,mpd_now.title) .. " - "
        string = string .. markup(colors.yellow,mpd_now.artist) .. "\n"
        string = string .. "\t" .. markup(colors.grey, mpd_now.album)
        if mpd_now.state == "stop" then
            string = "No music"
        elseif mpd_now.state == "N/A" then
            string = "No mpd server"
        end
        notification = naughty.notify({
            text = string,
            timeout = 0
        })
    end
    local hide_mpd_info = function ()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end

    -- Widget
    mpdwidget = lain.widgets.mpd({
        settings = function ()
            local string = mpd_now.title

            if mpd_now.state == "play" then
                string = "♪" .. string
            elseif mpd_now.state == "pause" then
                string = "■" .. string
            else
                string = "♮"
            end
            widget:set_markup(string)
            widget:connect_signal('mouse::enter', show_mpd_info)
            widget:connect_signal('mouse::leave', hide_mpd_info)
            widget:buttons(awful.util.table.join(
                awful.button({}, 1,
                    function ()
                        awful.util.spawn_with_shell("ncmpcpp toggle")
                        settings.widgets.mpd.update()
                    end),
                awful.button({}, 3,
                    function ()
                        awful.util.spawn_with_shell("ncmpcpp next")
                        settings.widgets.mpd.update()
                    end)))
        end
    })
    --}}

    -- Taskwarrior widget
    local taskwarrior = wibox.widget.textbox("tasks")
    lain.widgets.contrib.task:attach(
        taskwarrior,
        {
            font_size = 8,
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            position = "top_right",
            timeout = 7
        }
    )

    -- Redshift widget
    local rshift = wibox.widget.textbox("rs")
    lain.widgets.contrib.redshift:attach(
        rshift,
        function ()
            if lain.widgets.contrib.redshift:is_active() then
                rshift:set_markup(markup(colors.red,"⬤"))
            else
                rshift:set_markup(markup(colors.grey,"⬤"))
            end
        end
    )

    -- BTC widget
    local btcwidget = lain.widgets.contrib.ccurr({
        settings = function ()
            local btc = markup(colors.grey, price_now.btc)
            widget:set_markup("BTC " .. btc)
        end
    })

    settings.widgets = {
        space = space,
        separator = separator,
        clock = textclock,
        bat = batwidget,
        mem = memory,
        cpu = cpuwidget,
        root_du = root_disk_usage,
        net = net,
        sysload = sysload,
        vol = volwidget,
        mpd = mpdwidget,
        redshift = rshift,
        task = taskwarrior,
        btc = btcwidget
    }

end

return widgets
