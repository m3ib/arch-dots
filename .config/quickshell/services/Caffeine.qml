// Caffeine mode

import Quickshell
import Quickshell.Io
import QtQuick

pragma Singleton

Singleton {
  id: root

  property bool isRunning: false

  function toggle() {
    root.isRunning = !root.isRunning;
  }

  Process {
    running: root.isRunning
    command: ["sh", "-c", "systemd-inhibit --what=idle:sleep --who=caffeine-mode --why='Too much coffee' sleep inf"]
    stdout: StdioCollector {
      onStreamFinished: {
        if (root.isRunning) {
          console.error("Caffeine mode ended abruptly.");
          root.isRunning = false;
        }
      }
    }
  }
}
