require("hyprland.config")
require("hyprland.monitors")
require("hyprland.startup")
require("hyprland.keybinds")
require("hyprland.looks")
require("hyprland.input")
require("hyprland.rules")
require("hyprland.env")

hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

hl.on("hyprland.shutdown", function()
  os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
  -- uses a blocking exec function and sleeps a bit to give things time to close
  -- you might also want to kill troublesome/crashing non-systemd background services here:
  -- os.execute("pkill wallpaperthing; systemctl --user stop hyprland-session.target && sleep 0.1")
end)

hl.config({
  misc = {
    force_default_wallpaper = 1,
    disable_hyprland_logo = true,
  },
})
