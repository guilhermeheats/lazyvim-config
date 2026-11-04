local wezterm = require("wezterm")
local config = wezterm.config_builder()

--- Font ---
config.font = wezterm.font_with_fallback({
  "MesloLGS NF",
  "JetBrainsMono Nerd Font",
  "OpenDyslexic Nerd Font",
  "OpenDyslexic",
})
config.font_size = 14.5
config.line_height = 1.0

--- Palette ---
--- Dracula ---
config.colors = {
  foreground = "#F8F8F2",
  background = "#282A36",
  cursor_bg = "#F8F8F2",
  cursor_fg = "#282A36",
  cursor_border = "#F8F8F2",
  selection_bg = "#44475A",
  selection_fg = "#F8F8F2",
  ansi = {
    "#21222C",
    "#FF5555",
    "#50FA7B",
    "#F1FA8C",
    "#BD93F9",
    "#FF79C6",
    "#8BE9FD",
    "#F8F8F2",
  },
  brights = {
    "#6272A4",
    "#FF6E6E",
    "#69FF94",
    "#FFFFA5",
    "#D6ACFF",
    "#FF92DF",
    "#A4FFFF",
    "#FFFFFF",
  },
  tab_bar = {
    background = "#21222C",
    active_tab = { bg_color = "#44475A", fg_color = "#F8F8F2" },
    inactive_tab = { bg_color = "#282A36", fg_color = "#6272A4" },
    inactive_tab_hover = { bg_color = "#44475A", fg_color = "#F8F8F2" },
    new_tab = { bg_color = "#282A36", fg_color = "#6272A4" },
    new_tab_hover = { bg_color = "#44475A", fg_color = "#F8F8F2" },
  },
}

--- Windows / Tabs ---
config.window_background_opacity = 0.90
config.window_padding = { left = 4, right = 4, top = 4, bottom = 4 }
config.enable_scroll_bar = true
config.window_close_confirmation = "NeverPrompt"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_max_width = 30
config.tab_bar_at_bottom = false

--- Cursor / Ring ---
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.audible_bell = "Disabled"

--- Shell & Render ---
config.default_prog = { "/usr/bin/zsh", "-l" }
config.scrollback_lines = 5000
config.front_end = "OpenGL"
config.max_fps = 120
config.check_for_updates = false

return config
