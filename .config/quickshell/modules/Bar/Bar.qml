// The shell's bar
// Widgets are loaded in LeftSection, CenterSection, or RightSection

import Quickshell
import Quickshell.Wayland
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
      WlrLayershell.layer: WlrLayer.Bottom

      anchors {
        top: true
        right: true
        left: true
      }

      implicitHeight: modelData.height // fullscreen

      color: "transparent"
      mask: Region { item: rect }
      exclusiveZone: Config.size.bar


      // responsible for the dimensions of the actual bar
      Rectangle {
        id: rect

        anchors.top: parent.top
        width: parent.width
        height: Config.size.bar
        color: "transparent"

        RowLayout {
          anchors.fill: parent
          spacing: Config.spacing.barSection

          LeftSection {
            Layout.fillWidth: true
            Layout.fillHeight: true
          }

          CenterSection {
            Layout.fillHeight: true
          }

          RightSection {
            Layout.fillWidth: true
            Layout.fillHeight: true
          }
        }
      }
    }
  }
}
