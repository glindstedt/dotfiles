local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- config.color_scheme = "Tomorrow Night"
config.color_scheme = "tokyonight_night"

config.window_decorations = "RESIZE"

config.adjust_window_size_when_changing_font_size = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = true

config.front_end = "WebGpu"

-- config.font = wezterm.font("Fira Code Nerd Font")
config.font_size = 10
-- config.window_background_image = "/home/glindstedt/Pictures/4k_helmet_no_icon-wallpaper.jpg"
-- config.window_background_gradient = {
--   colors = { "#EEBD89", "#D13ABD" },
--   -- Specifices a Linear gradient starting in the top left corner.
--   orientation = { Linear = { angle = -45.0 } },
-- }
-- config.window_background_image_hsb = {
--   -- Darken the background image by reducing it to 1/3rd
--   brightness = 0.05,
--
--   -- You can adjust the hue by scaling its value.
--   -- a multiplier of 1.0 leaves the value unchanged.
--   hue = 1.0,
--
--   -- You can adjust the saturation also.
--   saturation = 1.0,
-- }
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

local act = wezterm.action

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  { mods = "ALT", key = "n", action = act.ActivateTabRelative(1) },
  { mods = "ALT", key = "p", action = act.ActivateTabRelative(-1) },
  { mods = "ALT|SHIFT", key = "n", action = act.MoveTabRelative(1) },
  { mods = "ALT|SHIFT", key = "p", action = act.MoveTabRelative(-1) },
  { mods = "ALT|SHIFT", key = "t", action = act.SpawnTab("DefaultDomain") },
  -- { mods = "ALT|SHIFT",    key = "c", action = act.CloseCurrentPane({ confirm = false }) },
  { mods = "LEADER|SHIFT", key = "|", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { mods = "LEADER", key = "-", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { mods = "LEADER", key = "x", action = act.CloseCurrentPane({ confirm = false }) },
  { mods = "ALT", key = "h", action = act.ActivatePaneDirection("Left") },
  { mods = "ALT", key = "j", action = act.ActivatePaneDirection("Down") },
  { mods = "ALT", key = "k", action = act.ActivatePaneDirection("Up") },
  { mods = "ALT", key = "l", action = act.ActivatePaneDirection("Right") },
  { mods = "ALT", key = "b", action = act.RotatePanes("Clockwise") },
  { mods = "ALT", key = "Enter", action = act.DisableDefaultAssignment },

  {
    mods = "ALT|SHIFT",
    key = "r",
    action = act.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, _pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
}

return config
