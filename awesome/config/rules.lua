local awful = require("awful")
local beautiful = require("beautiful")
awful.rules = require("awful.rules")

local rules = {}

function rules.init(settings)

    awful.rules.rules = {
        { -- All clients will match this rule.
          rule = { },
          properties = { --remove ugly borders for maximised terminal
              border_width = beautiful.border_width,
              border_color = beautiful.border_normal,
              focus = awful.client.focus.filter,
              keys = settings.clientkeys,
              buttons = settings.clientbuttons,
              size_hints_honor = false
          }
        },
        {
          rule       = { class = "Vlc" },
          properties = { tag = settings.tags[1][4] }
        },
        {
          rule       = { class = "pinentry" },
          properties = { floating = true }
        },
        {
          rule       = { class = "gimp" },
          properties = { floating = true }
        },
        { -- Set wicd to floating
          rule       = { class = "Wicd-client.py" },
          properties = { floating = true }
        },
        { -- Set Firefox to always map on tags number 2 of screen 1.
          rule       = { class = "Firefox" },
          properties = { tag = settings.tags[1][2] }
        },
        { -- Set anki, skype and pidgin to tag 4 of screen 1 
          rule_any   = { class = {"Anki", "Skype", "Pidgin"} },
          properties = { tag = settings.tags[1][4] }
        }
    }

end

return rules
