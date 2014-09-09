local awful = require("awful")
local beautiful = require("beautiful")

local launcher = {}

function launcher.init(settings)
    -- {{{ Menu
    -- Create a laucher widget and a main menu
    local awesomemenu = {
        { "manual", settings.terminal .. " -e man awesome" },
        { "edit config", settings.editor_cmd .. " " .. awesome.conffile },
        { "restart awesome", awesome.restart },
        { "logout", awesome.quit },
        { "suspend", "systemctl suspend" },
        { "restart", "systemctl reboot" },
        { "shutdown", "systemctl poweroff" }
    }

    local appmenu = {
        { "firefox", "firefox"},
        { "spotify", "chromium --app=https://play.spotify.com"},
        { "reader", "chromium --app=http://blooming-lake-8484.herokuapp.com"},
        { "gvim", "gvim"},
        { "anki", "anki"},
        { "skype", "skype"},
        { "gimp", "gimp"}
    }

    local google_apps = {}
    google_apps.drive = "chromium --app=https://drive.google.com/#my-drive"
    google_apps.mail = "chromium --app=https://mail.google.com"
    google_apps.cal = "chromium --app=https://calendar.google.com"
    google_apps.music = "chromium --app=https://play.google.com/music/listen#start"
    google_apps.plus = "chromium --app=https://plus.google.com/"

    local google_apps_menu = {
        {"drive", google_apps.drive},
        {"gmail", google_apps.mail},
        {"calendar", google_apps.cal},
        {"play music", google_apps.music},
        {"google+", google_apps.plus},
    }

    settings.mainmenu = awful.menu({
        items = { { "awesome", awesomemenu, beautiful.awesome_icon },
                  { "apps", appmenu, beautiful.awesome_icon },
                  { "google apps", google_apps_menu, beautiful.awesome_icon },
                  { "open terminal", settings.terminal }
        }
    })

    settings.launcher = awful.widget.launcher(
        {
            image = beautiful.awesome_icon,
            menu = settings.mainmenu
        }
    )

end

return launcher
