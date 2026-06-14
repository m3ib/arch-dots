// A base component for building variants of Progress OSDs

import Quickshell
import QtQuick
import QtQuick.Controls.Basic

import qs.components
import qs.services

Item {
  id: root

  property real percentage: 0.2
  property string icon: ""

  // animation properties
  property real animDuration: 120
  property real startOpacity: 0.2
  property real startY: 20

  height: parent.height
  width: progress.width + Config.spacing.progressOsdPadding*2

  visible: false // by-default

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
  }

  function hide() {
    root.y = startY
    root.opacity = startOpacity
    hideTimer.running = true
  }

  Timer {
    id: hideTimer

    running: false
    interval: animDuration
    onTriggered: {
      root.visible = false
    }
  }

  Rectangle {
    anchors.fill: parent
    color: Config.clr.bg
    radius: Config.size.rounding + Config.spacing.progressOsdPadding
  }

  ProgressBar {
    id: progress

    anchors.centerIn: parent
    height: parent.height - Config.spacing.progressOsdPadding*2

    value: root.percentage
    padding: 2

    background: Rectangle {
      implicitWidth: 40
      implicitHeight: parent.height
      color: Config.clr.bgLt
      radius: Config.size.rounding
    }

    contentItem: Item {
      Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: progress.visualPosition * parent.height
        radius: Config.size.rounding
        color: Config.clr.primary
      }

      // extra bar for values above 1.0
      Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: Math.max(0, root.percentage - 1) * parent.height
        radius: Config.size.rounding
        color: Config.clr.danger
      }

      Text {
        id: icon

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 4

        text: root.icon
        font.pixelSize: Config.fontSize.iconL
      }
    }
  }
}
