-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices.

function tab_title(tab_info)
  local title = tab_info.active_pane.foreground_process_name
  if title and #title > 0 then
    return title
  end

  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab_title(tab)
  local text = "  "
  if tab.is_active then
    text = "  "
  end
  return {
    { Foreground = { Color = "${TTY_COLOR_RED}" } },
    { Background = { Color = "${TTY_COLOR_BG0}" } },
    { Text = text },
  }
end)

config.initial_cols = 511
config.initial_rows = 511
config.audible_bell = "Disabled" -- disable audio bell
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Bold" })
config.font_size = 11.5
config.warn_about_missing_glyphs = false
config.use_fancy_tab_bar = false
config.freetype_load_target = "HorizontalLcd"
config.freetype_render_target = "HorizontalLcd"
config.window_decorations = "NONE"
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = ${TTY_INACTIVE_PANE_BRIGHTNESS},
}
config.hide_tab_bar_if_only_one_tab = true

config.colors = {
  foreground = "${TTY_COLOR_FG0}",
  background = "${TTY_COLOR_BG0}",
  cursor_bg = "${TTY_COLOR_FG0}",
  cursor_fg = "${TTY_COLOR_BG0}",
  split = "${TTY_COLOR_BG2}",
  selection_bg = "${TTY_COLOR_WHITE}",
  selection_fg = "${TTY_COLOR_BG0}",

  ansi = {
    "${TTY_COLOR_BLACK}",
    "${TTY_COLOR_RED}",
    "${TTY_COLOR_GREEN}",
    "${TTY_COLOR_YELLOW}",
    "${TTY_COLOR_BLUE}",
    "${TTY_COLOR_MAGENTA}",
    "${TTY_COLOR_CYAN}",
    "${TTY_COLOR_WHITE}",
  },
  brights = {
    "${TTY_COLOR_BRIGHT_BLACK}",
    "${TTY_COLOR_BRIGHT_RED}",
    "${TTY_COLOR_BRIGHT_GREEN}",
    "${TTY_COLOR_BRIGHT_YELLOW}",
    "${TTY_COLOR_BRIGHT_BLUE}",
    "${TTY_COLOR_BRIGHT_MAGENTA}",
    "${TTY_COLOR_BRIGHT_CYAN}",
    "${TTY_COLOR_BRIGHT_WHITE}",
  },
  tab_bar = {
    background = "${TTY_COLOR_BG0}",
    -- Disable new tab by hiding under bg color.
    new_tab = {
      fg_color = "${TTY_COLOR_BG0}",
      bg_color = "${TTY_COLOR_BG0}",
    },
    new_tab_hover = {
      fg_color = "${TTY_COLOR_BG0}",
      bg_color = "${TTY_COLOR_BG0}",
    },
  },
}

config.window_frame = {
  active_titlebar_bg = "${TTY_COLOR_BG2}",
  inactive_titlebar_bg = "${TTY_COLOR_BG2}",
}

local function is_editor(pane)
  local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
  return process_name == 'nvim' or process_name == 'vim' or string.find(process_name, 'emacs')
end

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function editor_nav_key(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'ALT|SHIFT' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_editor(pane) then
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'ALT|SHIFT' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

-- config.disable_default_key_bindings = true
config.leader = { key = "Space", mods = "CTRL" }
config.keys = {
  { key = "Space", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
  {
    key = "\\",
    mods = "LEADER",
    action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
  },
  {
    key = '"',
    mods = "LEADER|SHIFT",
    action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
  },
  {
    key = "%",
    mods = "LEADER|SHIFT",
    action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
  },
  { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
  { key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
  { key = "h", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-left" }) },
  { key = "j", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-down" }) },
  { key = "k", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-up" }) },
  { key = "l", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-right" }) },
  { key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
  { key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
  { key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
  {
    key = "L",
    mods = "LEADER|SHIFT",
    action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }),
  },
  { key = "h", mods = "ALT", action = wezterm.action({ ActivateTabRelative = -1 }) },
  { key = "l", mods = "ALT", action = wezterm.action({ ActivateTabRelative = 1 }) },
  {
    key = "x",
    mods = "LEADER",
    action = wezterm.action({ CloseCurrentPane = { confirm = false } }),
  },
  { key = "[", mods = "LEADER", action = "ActivateCopyMode" },
  {
    key = "UpArrow",
    mods = "SHIFT|CMD",
    action = wezterm.action.ToggleFullScreen,
  },
  editor_nav_key("move", "h"),
  editor_nav_key("move", "j"),
  editor_nav_key("move", "k"),
  editor_nav_key("move", "l"),
  -- resize panes
  editor_nav_key("resize", "h"),
  editor_nav_key("resize", "j"),
  editor_nav_key("resize", "k"),
  editor_nav_key("resize", "l"),
}

return config
