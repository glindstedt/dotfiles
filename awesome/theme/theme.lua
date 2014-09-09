---------------------------
-- Default awesome theme --
---------------------------

local colors = require("config/colors")

-- {{{ Meta
awesomedir = os.getenv("HOME") .. "/.config/awesome"
themedir = awesomedir .. "/theme"

theme = {}

-- Theme font
theme.font         = "cure 7"--nice terminator:"ter-212n 7" -- Default font: sans
-- Icons
theme.awesome_icon = themedir .. "/icons/xbm8x8/arch_10x10.png"
-- }}}

-- lain stuff
theme.useless_gap_width = 10

-- {{{ Colors, grab them from the colors file
theme.bg_normal     = colors.bg_normal --#262626 #0F190E
theme.bg_focus      = colors.bg_focus -- DarkGreen:#0F210E  Highlight:#4C6A29  ToolTipBase:#5C8B29
theme.bg_urgent     = colors.bg_urgent
theme.bg_minimize   = colors.bg_minimize

theme.fg_normal     = colors.fg_normal
theme.fg_focus      = colors.fg_focus
theme.fg_urgent     = colors.fg_urgent
theme.fg_minimize   = colors.fg_minimize
--- }}}

-- {{{ Borders
theme.border_width  = "1"
theme.border_normal = colors.border_normal
theme.border_focus  = colors.border_focus
theme.border_marked = colors.border_marked
--- }}}


-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
-- theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"



-- {{{ Titlebar

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
-- Display the taglist squares
theme.taglist_squares_sel   = themedir .. "/taglist/squarefz.png"
theme.taglist_squares_unsel = themedir .. "/taglist/squarez.png"
-- Annoying "maximized" icon
-- theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"

theme.titlebar_close_button_normal = themedir .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themedir .. "/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = themedir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themedir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themedir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themedir .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themedir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themedir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themedir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themedir .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themedir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themedir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themedir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themedir .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themedir .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themedir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themedir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themedir .. "/titlebar/maximized_focus_active.png"
-- }}}


--{{{ Wallpaper
theme.wallpaper = themedir .. "/background.symlink"
--}}}


-- {{{ Layout icons
theme.layout_fairh = themedir .. "/layouts/fairh.png"
theme.layout_fairv = themedir .. "/layouts/fairv.png"
theme.layout_floating  = themedir .. "/layouts/floating.png"
theme.layout_magnifier = themedir .. "/layouts/magnifier.png"
theme.layout_max = themedir .. "/layouts/max.png"
theme.layout_fullscreen = themedir .. "/layouts/fullscreen.png"
theme.layout_tilebottom = themedir .. "/layouts/tilebottom.png"
theme.layout_tileleft   = themedir .. "/layouts/tileleft.png"
theme.layout_tile = themedir .. "/layouts/tile.png"
theme.layout_tiletop = themedir .. "/layouts/tiletop.png"
theme.layout_spiral  = themedir .. "/layouts/spiral.png"
theme.layout_dwindle = themedir .. "/layouts/dwindle.png"
-- }}}


return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
