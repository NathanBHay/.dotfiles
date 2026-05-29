local mainMod = 'SUPER' -- Sets "Windows" key as main modifier

-- Applications
local terminal = 'kitty'
local launcher = 'rofi -show drun -theme ~/.config/rofi/rofi.rasi'
local notes = 'obsidian'
local browser = 'zen-beta'
local calendar = 'super-productivity'
local calculator = 'qalculate-qt'
local zotero = 'zotero'

-- Function keys
local brightnessUp = 'brightnessctl set 5%+ --exponent=3'
local brightnessDown = 'brightnessctl set 5%- --exponent=3'
local audioUp = 'wpctl set-mute @DEFAULT_SINK@ 0 && wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%+'
local audioDown = 'wpctl set-volume @DEFAULT_SINK@ 5%-'
local audioUpOvr = 'wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%+'
local audioMute = 'wpctl set-mute @DEFAULT_SINK@ toggle'
local audioPlay = 'playerctl play-pause'
local audioNext = 'playerctl next'
local audioPrev = 'playerctl previous'
local audioStop = 'playerctl stop'

-- Actions
local escape = 'hyprpanel t powerdropdownmenu'
local screenshot = 'screeny="$HOME/Pictures/Screenshots/$(date \'+%Y-%m-%d_%H-%M-%S\').png" && wayshot -g --clipboard "$screeny"'
local screenshot5 = 'sleep 5; ' .. screenshot

-------------
--- Input ---
-------------

hl.config {
  input = {
    kb_layout = 'us',
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
    },
  },
}

--------------------
--- KEYBINDINGSS ---
--------------------

local function browserWindow(window)
  return browser .. ' --new-window "' .. window .. '"'
end

local function bindCMD(key, cmd, is_locked_repeating)
  local flags = {}
  if is_locked_repeating then
    flags = { locked = true, repeating = true }
  end
  hl.bind(key, hl.dsp.exec_cmd(cmd), flags)
end

local function bindMod(key, callback, flags)
  hl.bind(mainMod .. ' + ' .. key, callback, flags)
end

local function bindModCMD(key, cmd, flags)
  bindCMD(mainMod .. ' + ' .. key, cmd, flags)
end

-- Laptop function keys
bindCMD('XF86MonBrightnessUp', brightnessUp, true)
bindCMD('XF86MonBrightnessDown', brightnessDown, true)

bindCMD('XF86AudioRaiseVolume', audioUp, true)
bindCMD('XF86AudioLowerVolume', audioDown, true)
bindModCMD('XF86AudioRaiseVolume', audioUpOvr)
bindModCMD('XF86AudioLowerVolume', audioDown)

bindCMD('XF86AudioMute', audioMute, true)
bindCMD('XF86AudioPlay', audioPlay, true)
bindCMD('XF86AudioNext', audioNext, true)
bindCMD('XF86AudioPrev', audioPrev, true)
bindCMD('XF86AudioStop', audioStop, true)

bindCMD('Print', screenshot)
bindModCMD('P', screenshot)
bindModCMD('Print', screenshot5)

bindCMD('F1', browserWindow 'https://search.nixos.org/options')
bindModCMD('F1', browserWindow 'https://search.nixos.org/packages')
bindModCMD('SHIFT + CTRL + ALT + L', browserWindow 'https://www.linkedin.com/')
bindCMD('XF86Calculator', calculator)

-- Escape Bindings
bindModCMD('Escape', escape)
bindModCMD('SHIFT + Escape', 'hyprlock')

-- Launchers
bindModCMD('Q', terminal)
bindModCMD('W', browser)
bindModCMD('SHIFT + W', browser .. ' --private-window')
bindModCMD('E', notes)
bindModCMD('R', launcher)
bindModCMD('T', calendar)
bindModCMD('Y', zotero)

bindMod(mainMod .. ' + C', hl.dsp.window.close())
hl.bind('ALT + F4', hl.dsp.window.close())

-- Change Layout
bindMod('SEMICOLON', hl.dsp.layout 'togglesplit')
bindMod('F', hl.dsp.window.float { action = 'toggle' })
-- hl.bind(mainMod .. " + B", togglegroup)

bindMod('S', hl.dsp.workspace.toggle_special 'magic')
bindMod('SHIFT + S', hl.dsp.window.move { workspace = 'special:magic' })

local directions = {
  { 'left', 'H', { -1, 0 } },
  { 'down', 'J', { 0, 1 } },
  { 'up', 'k', { 0, -1 } },
  { 'right', 'L', { 1, 0 } },
}

for _, value in ipairs(directions) do
  -- Move Focus
  bindMod(value[2], hl.dsp.focus { direction = value[1] })
  bindMod(value[1], hl.dsp.focus { direction = value[1] })

  -- Move window
  bindMod('SHIFT + ' .. value[2], hl.dsp.window.move { direction = value[1] })

  -- Resize window
  bindMod('SHIFT + ' .. value[1], hl.dsp.window.resize { x = value[3][1] * 15, y = value[3][2] * 15, relative = true })
  bindMod('CTRL + SHIFT + ' .. value[1], hl.dsp.window.resize { x = value[3][1] * 60, y = value[3][2] * 60, relative = true })
end

-- Workspace Switch
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  bindMod(key, hl.dsp.focus { workspace = i })
  bindMod('SHIFT + ' .. key, hl.dsp.window.move { workspace = i })
end

bindMod('GRAVE', hl.dsp.window.move { workspace = 'empty' })
bindMod('SHIFT + GRAVE', hl.dsp.window.move { workspace = 'empty', follow = false })

-- Relative Workspace Switch
bindMod('mouse_down', hl.dsp.focus { workspace = 'e+1' })
bindMod('mouse_up', hl.dsp.focus { workspace = 'e-1' })

bindMod('SHIFT + mouse_down', hl.dsp.window.move { workspace = 'r+', follow = false })
bindMod('SHIFT + mouse_up', hl.dsp.window.move { workspace = 'r-', follow = false })
bindMod('SHIFT + EQUAL', hl.dsp.window.move { workspace = 'r+', follow = false })
bindMod('SHIFT + MINUS', hl.dsp.window.move { workspace = 'r-', follow = false })

-- Move/resize windows with mainMod + LMB/RMB and dragging
bindMod('mouse:272', hl.dsp.window.drag(), { mouse = true })
bindMod('mouse:273', hl.dsp.window.resize(), { mouse = true })
