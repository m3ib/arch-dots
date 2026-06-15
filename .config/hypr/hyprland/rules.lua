-- distribute a `wsCount` workspaces on each monitor in sequence
-- e.g. monitor1 gets 1-100, monitor2 gets 101-200, ...
local wsCount = 100
for w = 1, wsCount do
  for _, mon in pairs(hl.get_monitors()) do
    hl.workspace_rule({ workspace = tostring(w + (mon.id * wsCount)), monitor = mon.name })
  end
end
-- set the default workspace for each monitor
-- NOTE: this needs to be done manually, otherwise it fails on startup
hl.workspace_rule({ workspace = tostring((wsCount * 0) + 1), monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = tostring((wsCount * 1) + 1), monitor = "HDMI-A-1", default = true })

hl.config({ cursor = { default_monitor = "HDMI-A-1" } })

local suppressMaximizeRule = hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move = "20 monitor_h-120",
  float = true,
})
