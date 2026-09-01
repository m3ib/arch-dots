require("hyprland.config")
require("hyprland.startup")
require("hyprland.keybinds")
require("hyprland.looks")
require("hyprland.input")
require("hyprland.rules")
require("hyprland.env")

---Get all files with a `.lua` extension in a given directory.
---@param dir string
---@return table
function getLuaModules(dir)
  local i, t, pfile = 1, {}, io.popen("ls " .. dir)

  for filename in pfile:lines() do
    if string.match(filename, "%.lua$") then
      t[i] = string.match(filename, "(.+)%.lua$")
      i = i + 1
    end
  end

  return t
end

local userModules = getLuaModules("~/.config/hypr/user")
for _, mod in ipairs(userModules) do
  require("user." .. mod)
end

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
