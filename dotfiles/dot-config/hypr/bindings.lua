-- Variables
local mainMod = 'SUPER' -- Sets "Windows" key as main modifier

-- Applications
local terminal = 'kitty'
local launcher = 'noctalia msg panel-toggle launcher'
local notes = 'obsidian'
local browser = 'brave-origin-beta'
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
local lock = 'noctalia msg screen-lock'
local screenshot = 'noctalia msg screenshot-region'
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
bindCMD('SHIFT + Print', screenshot5)
bindModCMD('P', screenshot)
bindModCMD('SHIFT + P', screenshot5)

bindCMD('F1', browserWindow 'https://archlinux.org/packages/')
bindModCMD('F1', browserWindow 'https://aur.archlinux.org/')
bindModCMD('SHIFT + CTRL + ALT + L', browserWindow 'https://www.linkedin.com/')
bindCMD('XF86Calculator', calculator)

-- Escape Bindings
bindModCMD('SHIFT + Escape', lock)

-- Launchers
bindModCMD('Q', terminal)
bindModCMD('W', browser)
bindModCMD('SHIFT + W', browser .. ' --incognito')
bindModCMD('E', notes)
bindModCMD('R', launcher)
bindModCMD('T', calendar)
bindModCMD('Y', zotero)

bindMod(mainMod .. ' + C', hl.dsp.window.close())
hl.bind('ALT + F4', hl.dsp.window.close())

-- Change Layout
bindMod('SEMICOLON', hl.dsp.layout 'togglesplit')
bindMod('F', hl.dsp.window.float { action = 'toggle' })

local directions = {
  { 'left', 'H', -1, 0 },
  { 'down', 'J', 0, 1 },
  { 'up', 'k', 0, -1 },
  { 'right', 'L', 1, 0 },
}

for _, value in ipairs(directions) do
  local dir, key, dx, dy = table.unpack(value)
  -- Move Focus
  bindMod(key, hl.dsp.focus { direction = value[1] })

  -- Move window
  bindMod(dir, hl.dsp.window.move { direction = dir })
  bindMod('SHIFT + ' .. key, hl.dsp.window.move { direction = value[1] })

  -- Resize window
  bindMod('SHIFT + ' .. dir, hl.dsp.window.resize { x = dx * 15, y = dy * 15, relative = true })
  bindMod('CTRL + SHIFT + ' .. dir, hl.dsp.window.resize { x = dx * 60, y = dy * 60, relative = true })
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
