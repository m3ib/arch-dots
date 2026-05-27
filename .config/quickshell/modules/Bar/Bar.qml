// Show the bar and it's child modules

import Quickshell
import QtQuick

import qs.components
import qs.services

ShellRoot {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData

      anchors {
        top: true
        right: true
        left: true
      }

      color: "transparent"

      mask: Region { item: rect }
      exclusiveZone: Config.size.bar

      Corner {
        anchors.left: parent.left
        y: Config.size.bar
        angle: 90
      }

      Rectangle {
        id: rect

        anchors.top: parent.top

        width: parent.width
        height: Config.size.bar

        color: Config.clr.bg
      }

      Corner {
        anchors.right: parent.right
        y: Config.size.bar
        angle: 180
      }
    }
  }
}
