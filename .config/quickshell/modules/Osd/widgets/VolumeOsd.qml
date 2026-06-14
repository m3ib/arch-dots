// Shows the current volume whenever it changes

import Quickshell
import QtQuick

import qs.components
import qs.services

ProgressOsd {
  id: root

  percentage: Volume.volume
  icon: "󰓃"

  Connections {
    target: Volume

    function onNewData() {
      root.visible = true
      // ensure full interval is used
      timer.running = false
      timer.running = true
      show()
    }
  }

  Timer {
    id: timer

    running: false
    interval: Config.duration.osd
    onTriggered: {
      hide()
    }
  }
}
