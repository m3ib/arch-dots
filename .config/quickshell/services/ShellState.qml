// Manages short-term state of the shell, e.g. Workspaces is open/closed, Bar is collapsed
pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Singleton {
  property var leftBar: QtObject {
    property list<string> activeMonitors: [];

    /** Check whether the left bar is shown on the given monitor or not.
     * @param {String} mon The target monitor.
     * @return {Boolean}
     */
    function isShown(mon) {
      return leftBar.activeMonitors.includes(mon);
    }

    /** Show the left bar on the given monitor.
     * @param {String} mon The target monitor.
     */
    function show(mon) {
      if (leftBar.isShown(mon)) return;
      leftBar.activeMonitors = [...leftBar.activeMonitors, mon];
    }

    /** Show the left bar on the all monitors. */
    function showAll() {
      Hyprland.monitors.values.forEach((mon) => {
        if (leftBar.isShown(mon?.name)) return;
        leftBar.activeMonitors = [...leftBar.activeMonitors, mon];
      })
    }

    /** Hide the left bar on the given monitor.
     * @param {String} mon The target monitor.
     */
    function hide(mon) {
      leftBar.activeMonitors = leftBar.activeMonitors.filter((m) => m !== mon);
    }

    /** Hide the left bar on the all monitors. */
    function hideAll() {
      leftBar.activeMonitors = [];
    }

    /** Toggle the left bar on the given monitor.
     * @param {String} mon The target monitor.
     */
    function toggle(mon) {
      if (leftBar.isShown(mon)) {
        leftBar.hide(mon);
        return;
      }

      leftBar.show(mon);
    }
  }
  property var workspaces: QtObject {
    property bool show: false;
  }


  IpcHandler {
    target: "leftBar"

    function toggle(): void { leftBar.toggle(Hyprland.focusedMonitor?.name) }
    function showAll(): void { leftBar.showAll() }
    function hideAll(): void { leftBar.hideAll() }
  }

  IpcHandler {
    target: "workspaces"

    function toggle(): void { ShellState.workspaces.show = !ShellState.workspaces.show }
    function show(): void { ShellState.workspaces.show = true }
    function hide(): void { ShellState.workspaces.show = false }
  }
}
