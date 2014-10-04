local awful = require("awful")
local menubar = require("menubar")
local lain = require("lain")

local keybinds = {}

function keybinds.init(settings)

    local modkey = settings.modkey

    -- {{{ Mouse bindings
    root.buttons(awful.util.table.join(
        awful.button({ }, 3, function () settings.mainmenu:toggle() end),
        awful.button({ }, 4, awful.tag.viewnext),
        awful.button({ }, 5, awful.tag.viewprev)
    ))
    -- }}}

    -- {{{ Global bindings
    local globalkeys = awful.util.table.join(

        -- Awesome functions
        awful.key({ modkey, "Control" }, "r", awesome.restart),
        awful.key({ modkey, "Shift"   }, "q", awesome.quit),

        -- Main menu
        awful.key({ modkey }, "w", function () settings.mainmenu:show() end),

        -- Start terminal
        awful.key({ modkey }, "Return", function () awful.util.spawn(settings.terminal) end),

        -- Run prompt
        awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),

        -- Lua prompt
        awful.key({ modkey }, "x",
                  function ()
                      awful.prompt.run({ prompt = "Run Lua code: " },
                      mypromptbox[mouse.screen].widget,
                      awful.util.eval, nil,
                      awful.util.getdir("cache") .. "/history_eval")
                  end),

        -- Menubar
        awful.key({ modkey }, "p", function() menubar.show() end),


        -- Tag navigation
        awful.key({ modkey, "Ctrl" }, "Left",  awful.tag.viewprev ),
        awful.key({ modkey, "Ctrl" }, "Right", awful.tag.viewnext ),

        -- Layout manipulation
        awful.key({ modkey,           }, "'", function () awful.layout.inc(settings.layouts,  1) end),
        awful.key({ modkey, "Shift"   }, "'", function () awful.layout.inc(settings.layouts, -1) end),
        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)           end),
        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)           end),
        awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1)        end),
        awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1)        end),
        awful.key({ modkey,           }, "l", function () awful.tag.incmwfact( 0.05)             end),
        awful.key({ modkey,           }, "h", function () awful.tag.incmwfact(-0.05)             end),
        awful.key({ modkey, "Shift"   }, "h", function () awful.tag.incnmaster( 1)               end),
        awful.key({ modkey, "Shift"   }, "l", function () awful.tag.incnmaster(-1)               end),
        awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1)                  end),
        awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1)                  end),
        awful.key({ modkey, "Control" }, "n", awful.client.restore),

        -- Layout navigation
        awful.key({ modkey }, "u", awful.client.urgent.jumpto),
        awful.key({ modkey }, "j",
            function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ modkey }, "k",
            function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ modkey }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then client.focus:raise() end
            end),

        -- Move & resize windows in float
        awful.key({ modkey }, "Next",  function () awful.client.moveresize( 0,  20, 0, -40)    end),
        awful.key({ modkey }, "Prior", function () awful.client.moveresize(0, -20,  0,  40)    end),
        awful.key({ modkey }, "Home",  function () awful.client.moveresize( 20,  0, -40, 0)    end),
        awful.key({ modkey }, "End",   function () awful.client.moveresize( -20,  0, 40, 0)    end),
        awful.key({ modkey }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
        awful.key({ modkey }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
        awful.key({ modkey }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
        awful.key({ modkey }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),

        -- Audio keys
        awful.key({ }, "XF86AudioRaiseVolume", function ()
                                                   awful.util.spawn("/usr/bin/vol_up")
                                                   settings.widgets.vol.update()
                                               end),
        awful.key({ }, "XF86AudioLowerVolume", function ()
                                                   awful.util.spawn("/usr/bin/vol_down")
                                                   settings.widgets.vol.update()
                                               end),
        awful.key({ }, "XF86AudioMute",        function ()
                                                   awful.util.spawn("/usr/bin/mute_toggle")
                                                   settings.widgets.vol.update()
                                               end),

        -- MPD Controls
        awful.key({ }, "XF86AudioPlay", function ()
                                            awful.util.spawn_with_shell("mpc toggle")
                                            settings.widgets.mpd.update()
                                        end),
        awful.key({ }, "XF86AudioStop", function ()
                                            awful.util.spawn_with_shell("mpc stop")
                                            settings.widgets.mpd.update()
                                        end),
        awful.key({ }, "XF86AudioNext", function ()
                                            awful.util.spawn_with_shell("mpc next")
                                            settings.widgets.mpd.update()
                                        end),
        awful.key({ }, "XF86AudioPrev", function ()
                                            awful.util.spawn_with_shell("mpc prev")
                                            settings.widgets.mpd.update()
                                        end),

        -- Taskwarrior widget
        awful.key({ modkey, "Shift" }, "t", lain.widgets.contrib.task.show),

        -- PrintScreen
        awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end),

        -- {{ Hax to create bindings for Modkey+0 to tag #10
        awful.key({ modkey, }, "0", function ()
              local screen = mouse.screen
                if settings.tags[screen][10] then
                  awful.tag.viewonly(settings.tags[screen][10]) end end),
        awful.key({ modkey, "Control" }, "0",
                  function ()
                      local screen = mouse.screen
                      if settings.tags[screen][10] then
                          awful.tag.viewtoggle(settings.tags[screen][10])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "0",
                  function ()
                      if client.focus and settings.tags[client.focus.screen][10] then
                          awful.client.movetotag(settings.tags[client.focus.screen][10])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "0",
                  function ()
                      if client.focus and settings.tags[client.focus.screen][10] then
                          awful.client.toggletag(settings.tags[client.focus.screen][10])
                      end
                  end)
        -- }}
    )

    -- Compute the maximum number of digit we need, limited to 9
    local keynumber = 0
    for s = 1, screen.count() do
       keynumber = math.min(9, math.max(#settings.tags[s], keynumber)) -- 10 was #tags[s]
    end

    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it works on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, keynumber do
        globalkeys = awful.util.table.join(globalkeys,
            awful.key({ modkey }, "#" .. i + 9,
                      function ()
                          local screen = mouse.screen
                          if settings.tags[screen][i] then
                              awful.tag.viewonly(settings.tags[screen][i])
                          end
                      end),
            awful.key({ modkey, "Control" }, "#" .. i + 9,
                      function ()
                          local screen = mouse.screen
                          if settings.tags[screen][i] then
                              awful.tag.viewtoggle(settings.tags[screen][i])
                          end
                      end),
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus and settings.tags[client.focus.screen][i] then
                              awful.client.movetotag(settings.tags[client.focus.screen][i])
                          end
                      end),
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus and settings.tags[client.focus.screen][i] then
                              awful.client.toggletag(settings.tags[client.focus.screen][i])
                          end
                      end))
    end
    -- }}}


    -- {{{ Client keybindings
    settings.clientkeys = awful.util.table.join(
        awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
        awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
        awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
            end)
    ) -- }}}

    settings.clientbuttons = awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize))

    -- Set keys
    root.keys(globalkeys)
    -- }}}
end

return keybinds
