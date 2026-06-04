// Show the bar and it's child modules

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

        RowLayout {
          anchors.centerIn: parent
          width: parent.width - Config.spacing.barHPadding*2
          height: parent.height - Config.spacing.barVPadding*2
          spacing: Config.spacing.barSection

          Item {
            id: leftSection

            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
              anchors.fill: parent
              spacing: Config.spacing.barComp

              Text {
                id: clock

                color: Config.clr.fg
                text: Sys.fmtTime("hh:mm")
              }
            }
          }

          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
              id: rightSection

              anchors.right: parent.right
              layoutDirection: Qt.RightToLeft
              spacing: Config.spacing.barComp

              Battery {}
              Network {}
            }
          }
        }
      }

      Corner {
        anchors.right: parent.right
        y: Config.size.bar
        angle: 180
      }
    }
  }
}
