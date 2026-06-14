import Quickshell
import QtQuick

import qs.components
import qs.services

Item {
  id: root

  property string osdText: ""

  // animation properties
  property real animDuration: 120
  property real startOpacity: 0.2
  property real startY: Config.spacing.osdScreenGap

  width: txt.width + Config.spacing.osdHPadding*2
  height: txt.height + Config.spacing.osdVPadding*2

  visible: false

  // slide-in animation
  y: startY
  opacity: startOpacity

  Behavior on y {
    NumberAnimation { duration: animDuration; easing.type: Easing.InOutQuad }
  }
  Behavior on opacity {
    NumberAnimation { duration: animDuration }
  }

  function show() {
    root.visible = true
    root.y = 0
    root.opacity = 1
    // ensure full interval is used
    timer.running = false
    timer.running = true
  }

  function hide() {
    root.y = startY
    root.opacity = startOpacity
    animTimer.running = true
  }

  Timer {
    id: animTimer

    running: false
    interval: animDuration
    onTriggered: {
      root.visible = false
    }
  }

  Connections {
    target: OsdService

    function onTextualOsd(osdText) {
      root.osdText = osdText
      show()
    }
  }

  Timer {
    id: timer

    interval: Config.duration.osd
    running: false
    onTriggered: hide()
  }

  Rectangle {
    anchors.fill: parent
    color: Config.clr.bg
    border.width: 2
    border.color: Config.clr.bgLt
    radius: Config.size.rounding

    Text {
      id: txt

      text: root.osdText
      anchors.centerIn: parent
    }
  }
}
