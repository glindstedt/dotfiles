local awful = require("awful")
local beautiful = require("beautiful")

local layouts = {}

function layouts.init(settings)
    -- Table of layouts to cover with awful.layout.inc, order matters.
    settings.layouts =
    {
        awful.layout.suit.tile,
        awful.layout.suit.floating
    }

    -- {{{ Tags

    -- Define a tag table which hold all screen tags.
    -- This format is more readable, but must be converted to be used
    local tagdefs = {
        { "一", settings.layouts[1] },
        { "二", settings.layouts[1] },
        { "三", settings.layouts[1] },
        { "四", settings.layouts[2] },
        { "五", settings.layouts[2] },
        { "六", settings.layouts[2] },
        { "七", settings.layouts[2] },
        { "八", settings.layouts[2] },
        { "九", settings.layouts[2] },
        { "十", settings.layouts[2] }
    }

    -- {{ Convert tagdefs table into two lists
    local tagnames = {}
    local taglayouts = {}
    for index, tag in pairs(tagdefs) do
        tagnames[index] = tagdefs[index][1]
        taglayouts[index] = tagdefs[index][2]
    end
    -- }}

    -- Apply the tags to each screen
    settings.tags = {}
    for s = 1, screen.count() do
        settings.tags[s] = awful.tag(tagnames, s, taglayouts)
    end

    -- }}}

end

return layouts
