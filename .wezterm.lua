local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local project_dir = wezterm.home_dir .. "/src"

local function project_dirs()
  -- Start with your home directory as a project, 'cause you might want
  -- to jump straight to it sometimes.
  local proj_dirs = { wezterm.home_dir }

  -- WezTerm comes with a glob function! Let's use it to get a lua table
  -- containing all subdirectories of your project folder.
  for _, dir in ipairs(wezterm.glob(project_dir .. '/*')) do
    -- ... and add them to the projects table.
    table.insert(proj_dirs, dir)
  end

  return proj_dirs
end

local function choose_project()
  local choices = {}
  for _, value in ipairs(project_dirs()) do
    table.insert(choices, { label = value })
  end

  return wezterm.action.InputSelector {
    title = "Projects",
    choices = choices,
    fuzzy = true,
    action = wezterm.action_callback(function(child_window, child_pane, id, label)
      -- "label" may be empty if nothing was selected. Don't bother doing anything
      -- when that happens.
      if not label then return end

      -- The SwitchToWorkspace action will switch us to a workspace if it already exists,
      -- otherwise it will create it for us.
      child_window:perform_action(wezterm.action.SwitchToWorkspace {
        -- We'll give our new workspace a nice name, like the last path segment
        -- of the directory we're opening up.
        name = label:match("([^/]+)$"),
        -- Here's the meat. We'll spawn a new terminal with the current working
        -- directory set to the directory that was picked.
        spawn = { cwd = label },
      }, child_pane)
    end),
  }
end

wezterm.on("gui-startup", function()
    local _, _, window = mux.spawn_window {}
    window:gui_window():maximize()
end)

wezterm.on('update-status', function(window)
  window:set_right_status(wezterm.format({
    { Background = { Color = window:effective_config().colors.tab_bar.active_tab.fg_color } },
    { Foreground = { Color = window:effective_config().colors.tab_bar.active_tab.bg_color } },
    { Text = ' Workspace: ' .. window:active_workspace() .. ' ' },
  }))
end)

return {
  freetype_load_flags = 'FORCE_AUTOHINT',
  default_prog = { 'pwsh.exe', '-NoLogo' },
  default_cwd = wezterm.home_dir,
  font_size = 14.0,
  hide_tab_bar_if_only_one_tab = false,
  window_decorations = "INTEGRATED_BUTTONS|RESIZE",
  window_padding = {
    left   = 0,
    top    = 0,
    right  = 0,
    bottom = 0,
  },
  keys = {
    { key = 'f', mods = 'CTRL',       action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' }, },
    { key = "i", mods = "CTRL",       action = wezterm.action.DisableDefaultAssignment                         },
    { key = "g", mods = "SHIFT|CTRL", action = wezterm.action.ToggleFullScreen                                 },
    { key = 'p', mods = 'CTRL',       action = choose_project(),                                               },
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
