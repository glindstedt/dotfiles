local config = {
    -- Models ( defines structures )
    layouts = require("config.layouts"),
    launcher = require("config.launcher"),
    widgets = require("config.widgets"),
    -- Controllers ( defines how to interact with models )
    keybinds = require("config.keybinds"),
    toolbar = require("config.toolbar"),
    rules = require("config.rules"),
    signals = require("config.signals"),
    -- Util
    util = require("config.util")
}
return config
