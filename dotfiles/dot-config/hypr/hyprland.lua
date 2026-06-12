--------------------------------
--- Nathan's Hyprland Config ---
--------------------------------

require 'bindings'

----------------
--- MONITORS ---
----------------

hl.monitor {
  output = 'DP-2',
  mode = 'preferred',
  position = 'auto-left',
  scale = 'auto',
}

hl.monitor {
  output = 'eDP-1',
  mode = 'preferred',
  position = 'auto',
  scale = 'auto',
}

hl.monitor {
  output = '',
  mode = 'preferred',
  position = 'auto',
  scale = 'auto',
}

-----------------
--- AUTOSTART ---
-----------------

hl.on('hyprland.start', function()
  hl.exec_cmd 'noctalia'
  hl.exec_cmd 'noctalia msg screen-lock'
  hl.exec_cmd 'sleep 5 && mega-sync'
end)

-- Assume monitor added means logitech mouse is connected.
hl.on('monitor.added', function()
  hl.exec_cmd 'solaar --window=hide'
end)

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

local cursor_theme = 'catppuccin-mocha-light-cursors'
local cursor_size = '24'

hl.env('XCURSOR_SIZE', cursor_size)
hl.env('HYPRCURSOR_SIZE', cursor_size)
hl.env('XCURSOR_THEME', cursor_theme)
hl.env('HYPRCURSOR_THEME', cursor_theme)
hl.env('QT_QPA_PLATFORMTHEME', 'qt6ct')

---------------------
--- LOOK AND FEEL ---
---------------------

hl.config {
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 1,
    resize_on_border = true,
    extend_border_grab_area = 6,
    layout = 'dwindle',
  },

  decoration = {
    rounding = 0,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
    },

    blur = {
      enabled = true,
      size = 3,
      passes = 2,
      ignore_opacity = true,
    },
  },

  dwindle = {
    preserve_split = true, -- You probably want this
  },

  misc = {
    disable_hyprland_logo = true,
    enable_swallow = true,
    focus_on_activate = true,
  },

  cursor = { no_hardware_cursors = false },

  animations = { enabled = true },
}

------------------
--- Animations ---
------------------

hl.curve('fluent_decel', { type = 'bezier', points = { { 0, 0.2 }, { 0.4, 1 } } })
hl.curve('easeOutCirc', { type = 'bezier', points = { { 0, 0.55 }, { 0.45, 1 } } })
hl.curve('easeOutCubic', { type = 'bezier', points = { { 0.33, 1 }, { 0.68, 1 } } })
hl.curve('easeinoutsine', { type = 'bezier', points = { { 0.37, 0 }, { 0.63, 1 } } })

hl.animation { leaf = 'windowsIn', enabled = true, speed = 3, bezier = 'easeOutCubic', style = 'popin 30%' } -- window open
hl.animation { leaf = 'windowsOut', enabled = true, speed = 3, bezier = 'fluent_decel', style = 'popin 70%' } -- window close.
hl.animation { leaf = 'windowsMove', enabled = true, speed = 2, bezier = 'easeinoutsine', style = 'slide' } -- everything in between, moving, dragging, resizing.
hl.animation { leaf = 'fadeIn', enabled = true, speed = 3, bezier = 'easeOutCubic' } -- fade in (open) -> layers and windows
hl.animation { leaf = 'fadeOut', enabled = true, speed = 2, bezier = 'easeOutCubic' } -- fade out (close) -> layers and windows
hl.animation { leaf = 'fadeSwitch', enabled = false, speed = 1, bezier = 'easeOutCirc' } -- fade on changing activewindow and its opacity
hl.animation { leaf = 'fadeShadow', enabled = true, speed = 10, bezier = 'easeOutCirc' } -- fade on changing activewindow for shadows
hl.animation { leaf = 'fadeDim', enabled = true, speed = 4, bezier = 'fluent_decel' } -- the easing of the dimming of inactive windows
hl.animation { leaf = 'border', enabled = true, speed = 2.7, bezier = 'easeOutCirc' } -- for animating the border's color switch speed
hl.animation { leaf = 'borderangle', enabled = true, speed = 30, bezier = 'fluent_decel', style = 'once' } -- gradient move (once or loop)
hl.animation { leaf = 'workspaces', enabled = true, speed = 3.5, bezier = 'easeOutCubic', style = 'fade' } -- workspace transistion

------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------
-- Persistent workspaces. With two monitors the first gets 6 and the second 4;
-- with any other count they're split evenly across the connected monitors.
local TWO_MONITOR_SPLIT = { 6, 4 }

-- Connected monitors, primary first then left-to-right by x position.
local function ordered_monitors()
  local mons = {}
  for _, m in ipairs(hl.get_monitors()) do
    if not m.is_mirror then
      mons[#mons + 1] = m
    end
  end
  table.sort(mons, function(a, b)
    return a.x < b.x -- This is kinda a heuristic
  end)
  return mons
end

-- Two monitors use the explicit 6/4 split
local function assign_workspaces()
  local monitors = ordered_monitors()
  if #monitors == 1 or #monitors == 2 then
    local ws = 1
    for i, mon in ipairs(monitors) do
      for _ = 1, TWO_MONITOR_SPLIT[i] do
        hl.workspace_rule { monitor = mon.name, workspace = tostring(ws), persistent = true }
        ws = ws + 1
      end
    end
  end
end

hl.on('hyprland.start', assign_workspaces)
hl.on('monitor.added', assign_workspaces)
hl.on('monitor.removed', assign_workspaces)
hl.on('config.reloaded', assign_workspaces)

-- Rule to make a window of a title and class float
local function floatRule(opts)
  hl.window_rule {
    name = ('float-%s-%s'):format(opts.title or '', opts.class or ''),
    match = {
      title = opts.title,
      class = opts.class,
    },
    float = true,
  }
end

floatRule { title = '^((p|P)icture-in-(p|P)icture)$' }
floatRule { title = '^(Open File)$' }
floatRule { class = '^(dialog)$' }
floatRule { class = '^(download)$' }
floatRule { class = '^(error)$' }
floatRule { class = '^(xdg-desktop-portal-gtk)$' }
floatRule { title = '^(Open File)$' }
floatRule { title = '^(branchdialog)$' }
floatRule { title = '^(Confirm to replace files)$' }
floatRule { title = '^(File Operation Progress)$' }
floatRule { title = '^MEGA*' }
floatRule { title = '^(Bitwarden)$' }
floatRule { title = '^(Discord Popout)$' }

-- "Smart gaps" / "No gaps when only"
hl.workspace_rule { workspace = 'w[tv1]', gaps_out = 0, gaps_in = 0 }
hl.workspace_rule { workspace = 'f[1]', gaps_out = 0, gaps_in = 0 }
hl.window_rule {
  name = 'no-gaps-wtv1',
  match = { float = false, workspace = 'w[tv1]' },
  border_size = 0,
  rounding = 0,
}
hl.window_rule {
  name = 'no-gaps-f1',
  match = { float = false, workspace = 'f[1]' },
  border_size = 0,
  rounding = 0,
}
hl.window_rule {
  name = 'suppress-maximize-events',
  match = { class = '.*' },
  suppress_event = 'maximize',
}
local fs_prev = nil

hl.on('window.fullscreen', function(w)
  local cur = w.fullscreen
  local prev = fs_prev
  fs_prev = cur

  if prev == 2 and cur == 0 then
    -- left real fullscreen; the bogus maximize lands within a ms.
    hl.timer(function()
      fs_prev = nil
    end, { timeout = 1, type = 'oneshot' })
  elseif cur == 1 and fs_prev then
    -- Bogus maximize; unset fullscreen
    fs_prev = nil
    hl.dispatch(hl.dsp.window.fullscreen_state {
      internal = 0,
      client = 0,
      action = 'set',
      window = w,
    })
  end
end)

require 'noctalia'
