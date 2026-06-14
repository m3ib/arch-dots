// Container for all types of OSDs
// Controlled by OsdService

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

ShellRoot {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData

      screen: modelData
      WlrLayershell.layer: WlrLayer.Overlay
      visible: modelData.name == Hyprland.focusedMonitor?.name

      anchors {
        top: true
        right: true
        bottom: true
        left: true
      }

      color: "transparent"
      mask: Region {}
      exclusionMode: ExclusionMode.Ignore

      // a wrapper so TextualOsd can animate its y-coords
      // since anchors lock it in place
      Item {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: Config.spacing.osdScreenGap

        width:textualOsd.width
        height:textualOsd.height

        TextualOsd {
          id: textualOsd
        }
      }

      ProgressContainer {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: Config.spacing.osdScreenGap
      }
    }
  }
}

