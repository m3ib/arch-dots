local mainMod = "SUPER"

hl.bind(
  mainMod .. " + Super_L",
  hl.dsp.exec_cmd('rofi -show combi -modes "combi,Emoji:$HOME/.config/hypr/scripts/emoji.sh"')
)

-- apps
local terminal = "kitty"
local browser = "zen-browser"
local browserAlt = "brave"
local files = "thunar"
local filesAlt = "kitty ranger"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browserAlt))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(files))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(filesAlt))

-- window operations
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- move focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- move window
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- move window to monitor
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ monitor = "r" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ monitor = "u" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ monitor = "d" }))

-- compute the absolute workspace id in the current workspace group
function get_workspace(w)
  local wsGroup = math.floor((hl.get_active_workspace().id - 1) / 10) * 10
  return wsGroup + w
end

-- switch workspaces with mainMod + [0-9]
-- move active window to a workspace with mainMod + SHIFT + [0-9]
for w = 1, 10 do
  local key = w % 10 -- 10 maps to key 0

  hl.bind(mainMod .. " + " .. key, function()
    hl.dispatch(hl.dsp.focus({ workspace = get_workspace(w) }))
  end)
  hl.bind(mainMod .. " + SHIFT + " .. key, function()
    hl.dispatch(hl.dsp.window.move({ workspace = get_workspace(w) }))
  end)
  hl.bind(mainMod .. " + ALT + " .. key, function()
    hl.dispatch(hl.dsp.window.move({ workspace = get_workspace(w), follow = false }))
  end)
end

-- example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- layout specific
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + M", hl.dsp.layout("swapsplit"))

-- laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.global("volume:increment"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.global("volume:decrement"), { locked = true, repeating = true })
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  hl.dsp.global("volume:decrement"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.global("brightness:increment"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.global("brightness:decrement"), { locked = true, repeating = true })
-- pretty handy
hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.global("brightness:increment"), { locked = true, repeating = true })
hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.global("brightness:decrement"), { locked = true, repeating = true })

-- requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- utilities
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -zm region --clipboard-only"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m window -m active --clipboard-only"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m output -m active --clipboard-only"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("echo -n $(hyprpicker) | wl-copy"))

-- quickshell
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("qs ipc call workspaces toggle"))
