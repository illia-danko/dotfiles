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

config.line_height = 1.0
config.font_size = ${TTY_FONT_SIZE}

wezterm.on("increase-font-size", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.font_size = (overrides.font_size or config.font_size) + 1.0
  overrides.line_height = (overrides.line_height or config.line_height) + 0.4
  window:set_config_overrides(overrides)
end)

wezterm.on("decrease-font-size", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.font_size = math.max((overrides.font_size or config.font_size) - 1.0, ${TTY_FONT_SIZE}) -- Keep it reasonable
  overrides.line_height = math.max((overrides.line_height or config.line_height) - 0.4, 1.0) -- Keep it reasonable
  window:set_config_overrides(overrides)
end)

wezterm.on("reset-font-size", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.font_size = ${TTY_FONT_SIZE}
  overrides.line_height = 1.0
  window:set_config_overrides(overrides)
end)

config.initial_cols = 511
config.initial_rows = 511
config.audible_bell = "Disabled" -- disable audio bell
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Bold" })
config.warn_about_missing_glyphs = false
config.use_fancy_tab_bar = false
config.freetype_load_target = "HorizontalLcd"
config.freetype_render_target = "HorizontalLcd"
config.window_decorations = "NONE"
config.cell_width = 0.9 -- letter spacing
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
  split = "${TTY_COLOR_WHITE}",
  selection_bg = "${TTY_COLOR_FG0}",
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
  { key = ' ', mods = 'SHIFT', action = wezterm.action.SendKey { key = ' ' } },
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
  {
    key = "o",
    mods = "LEADER",
    -- Close all panes but the current one.
    action = wezterm.action_callback(function(window, pane)
      local tab = pane:tab()
      local panes = tab:panes()

      for _, p in ipairs(panes) do
        if p:pane_id() ~= pane:pane_id() then
          wezterm.run_child_process({'wezterm', 'cli', 'kill-pane' , '--pane-id', p:pane_id()})
        end
      end
    end)
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
  {
    key = "=",
    mods = "CTRL",
    action = wezterm.action.EmitEvent("increase-font-size"),
  },
  {
    key = "-",
    mods = "CTRL",
    action = wezterm.action.EmitEvent("decrease-font-size"),
  },
  {
    key = "0",
    mods = "CTRL",
    action = wezterm.action.EmitEvent("reset-font-size"),
  },
}

local act = wezterm.action
config.key_tables = {
  copy_mode = {
    { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    {
      key = 'Tab',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveBackwardWord',
    },
    {
      key = 'Enter',
      mods = 'NONE',
      action = act.CopyMode 'MoveToStartOfNextLine',
    },
    {
      key = 'Escape',
      mods = 'NONE',
      action = act.Multiple { { CopyMode =  'Close' } },
    },
    {
      key = 'Space',
      mods = 'NONE',
      action = act.CopyMode { SetSelectionMode = 'Cell' },
    },
    {
      key = '$',
      mods = 'NONE',
      action = act.CopyMode 'MoveToEndOfLineContent',
    },
    {
      key = '$',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToEndOfLineContent',
    },
    { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
    { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
    {
      key = 'F',
      mods = 'NONE',
      action = act.CopyMode { JumpBackward = { prev_char = false } },
    },
    {
      key = 'F',
      mods = 'SHIFT',
      action = act.CopyMode { JumpBackward = { prev_char = false } },
    },
    {
      key = 'G',
      mods = 'NONE',
      action = act.CopyMode 'MoveToScrollbackBottom',
    },
    {
      key = 'G',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToScrollbackBottom',
    },
    { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
    {
      key = 'H',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToViewportTop',
    },
    {
      key = 'L',
      mods = 'NONE',
      action = act.CopyMode 'MoveToViewportBottom',
    },
    {
      key = 'L',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToViewportBottom',
    },
    {
      key = 'M',
      mods = 'NONE',
      action = act.CopyMode 'MoveToViewportMiddle',
    },
    {
      key = 'M',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToViewportMiddle',
    },
    {
      key = 'O',
      mods = 'NONE',
      action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
    },
    {
      key = 'O',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
    },
    {
      key = 'T',
      mods = 'NONE',
      action = act.CopyMode { JumpBackward = { prev_char = true } },
    },
    {
      key = 'T',
      mods = 'SHIFT',
      action = act.CopyMode { JumpBackward = { prev_char = true } },
    },
    {
      key = 'V',
      mods = 'NONE',
      action = act.CopyMode { SetSelectionMode = 'Line' },
    },
    {
      key = 'V',
      mods = 'SHIFT',
      action = act.CopyMode { SetSelectionMode = 'Line' },
    },
    {
      key = '^',
      mods = 'NONE',
      action = act.CopyMode 'MoveToStartOfLineContent',
    },
    {
      key = '^',
      mods = 'SHIFT',
      action = act.CopyMode 'MoveToStartOfLineContent',
    },
    { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
    { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
    {
      key = 'c',
      mods = 'CTRL',
      action = act.Multiple { { CopyMode =  'Close' } },
    },
    {
      key = 'd',
      mods = 'CTRL',
      action = act.CopyMode { MoveByPage = 0.5 },
    },
    {
      key = 'e',
      mods = 'NONE',
      action = act.CopyMode 'MoveForwardWordEnd',
    },
    {
      key = 'f',
      mods = 'NONE',
      action = act.CopyMode { JumpForward = { prev_char = false } },
    },
    { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
    { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
    {
      key = 'g',
      mods = 'NONE',
      action = act.CopyMode 'MoveToScrollbackTop',
    },
    {
      key = 'g',
      mods = 'CTRL',
      action = act.Multiple { { CopyMode =  'Close' } },
    },
    { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
    {
      key = 'm',
      mods = 'ALT',
      action = act.CopyMode 'MoveToStartOfLineContent',
    },
    {
      key = 'o',
      mods = 'NONE',
      action = act.CopyMode 'MoveToSelectionOtherEnd',
    },
    {
      key = 'q',
      mods = 'NONE',
      action = act.Multiple { { CopyMode =  'Close' } },
    },
    {
      key = 't',
      mods = 'NONE',
      action = act.CopyMode { JumpForward = { prev_char = true } },
    },
    {
      key = 'u',
      mods = 'CTRL',
      action = act.CopyMode { MoveByPage = -0.5 },
    },
    {
      key = 'v',
      mods = 'NONE',
      action = act.CopyMode { SetSelectionMode = 'Cell' },
    },
    {
      key = 'v',
      mods = 'CTRL',
      action = act.CopyMode { SetSelectionMode = 'Block' },
    },
    { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    { key = 'y', mods = 'NONE', action = act.Multiple { { CopyTo =  'ClipboardAndPrimarySelection' }, act.CopyMode('ClearPattern'), { CopyMode =  'Close' }, act.ClearSelection } },
    { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
    { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
    {
      key = 'End',
      mods = 'NONE',
      action = act.CopyMode 'MoveToEndOfLineContent',
    },
    {
      key = 'Home',
      mods = 'NONE',
      action = act.CopyMode 'MoveToStartOfLine',
    },
    { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    {
      key = 'LeftArrow',
      mods = 'ALT',
      action = act.CopyMode 'MoveBackwardWord',
    },
    {
      key = 'RightArrow',
      mods = 'NONE',
      action = act.CopyMode 'MoveRight',
    },
    {
      key = 'RightArrow',
      mods = 'ALT',
      action = act.CopyMode 'MoveForwardWord',
    },
    { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    { key="/", mods="NONE", action=wezterm.action{Search={CaseSensitiveString=""}} },
    -- navigate any search mode results
    { key="n", mods="NONE", action=wezterm.action{CopyMode="NextMatch" } },
    { key="N", mods="SHIFT", action=wezterm.action{CopyMode="PriorMatch" } },
    { key="Escape", mods="NONE", action= act.Multiple { act.CopyMode('ClearPattern'), { CopyMode =  'Close' }, act.ClearSelection } },
    { key="c", mods="CTRL", action= act.Multiple { act.CopyMode('ClearPattern'), { CopyMode =  'Close' }, act.ClearSelection } }
  },
  search_mode = {
    { key="Enter", mods="NONE", action="ActivateCopyMode" },
    { key="Escape", mods="NONE", action = act.Multiple { act.CopyMode('ClearPattern'), act.ClearSelection, act.ActivateCopyMode } },
    { key="c", mods="CTRL", action = act.Multiple { act.CopyMode('ClearPattern'), act.ClearSelection, act.ActivateCopyMode } }
  },
}

return config
