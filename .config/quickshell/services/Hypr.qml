// Hyprland functions

import Quickshell
import Quickshell.Hyprland
import QtQuick

pragma Singleton

Singleton {
  function getIcon(app) {
    return Quickshell.iconPath(app, DesktopEntries.heuristicLookup(app)?.icon)
  }

  function isFocusedMonitor(mon) {
    return mon === Hyprland.focusedMonitor?.name
  }
}
