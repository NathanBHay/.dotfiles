--------------------------------
--- Nathan's Hyprland Config ---
--------------------------------

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
  hl.exec_cmd 'hyprlock'
  hl.exec_cmd 'hypridle'
  hl.exec_cmd 'hyprpanel'
  hl.exec_cmd 'awww-daemon'
  hl.exec_cmd 'hyprsunset'
  hl.exec_cmd 'sleep 5 && mega-sync'
end)

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

hl.env('XCURSOR_SIZE', '24')
hl.env('HYPRCURSOR_SIZE', '24')
hl.env('XDG_CURRENT_DESKTOP', 'Hyprland')

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
      -- Test this out
      -- vibrancy  = 0.1696,
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
hl.animation { leaf = 'workspaces', enabled = true, speed = 4, bezier = 'easeOutCubic', style = 'fade' } -- worksapce transistion

------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

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

hl.layer_rule {
  name = 'no-anim-overlay',
  match = { namespace = '^(rofi)$' },
  no_anim = true,
}

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
