local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local font_a = wezterm.font('Terminess Nerd Font', { weight = 'Regular', style = 'Normal' })
local font_a_rules = {
  {
    italic = true,
    intensity = 'Bold',
    font = font_a,
  },
  {
    italic = false,
    intensity = 'Bold',
    font = font_a,
  },
  {
    italic = true,
    intensity = 'Normal',
    font = font_a,
  },
}
local font_b = wezterm.font('JetBrainsMono Nerd Font')
local font_b_rules = {}
local current_font = font_a

wezterm.on("gui-startup", function()
    local _, _, window = mux.spawn_window {}
    window:gui_window():maximize()
end)

wezterm.on('toggle-font', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  
  if current_font == font_a then
    current_font = font_b
    overrides.font = current_font
    overrides.font_rules = font_b_rules
  else
    current_font = font_a
    overrides.font = current_font
    overrides.font_rules = font_a_rules
  end

  window:set_config_overrides(overrides)
end)

return {
  font_size = 12.0,
  font = font_a,
  font_rules = font_a_rules,
  default_prog = { 'pwsh.exe', '-NoLogo' },
  default_cwd = wezterm.home_dir,
  hide_tab_bar_if_only_one_tab = false,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  enable_scroll_bar = true,
  window_padding = {
    left   = 0,
    top    = 0,
    right  = 0,
    bottom = 0,
  },
  keys = {
    { key = "i", mods = "CTRL",       action = wezterm.action.DisableDefaultAssignment },
    { key = "g", mods = "SHIFT|CTRL", action = wezterm.action.ToggleFullScreen         },
    { key = "e", mods = "CTRL",       action = act.EmitEvent "toggle-font" },
  },
  mouse_bindings = {
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = act.PasteFrom 'Clipboard'
    }
  },
  colors = {
    tab_bar = {
      active_tab = {
        bg_color = '#000000',
        fg_color = '#c0ffc0',
        intensity = 'Bold',
        underline = 'None',
      },
    },
  },
}
