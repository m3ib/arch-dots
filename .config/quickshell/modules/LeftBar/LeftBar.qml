// A Left bar for all kind of miscellanous tools

import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

ShellRoot {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: root

      property var modelData

      property list<string> sectionComponents: ["ClockSection.qml", "WallSection.qml"]
      property list<string> sectionIcons: ["󰀠", "󰸉"]
      property real activeSection: 0

      screen: modelData
      WlrLayershell.layer: WlrLayer.Top
      focusable: true

      anchors {
        top: true
        left: true
        bottom: true
      }

      implicitWidth: modelData.width * 0.2

      color: "transparent"
      mask: Region { item: rect }
      visible: Hypr.isFocusedMonitor(modelData?.name) && ShellState.leftBar.show

      Rectangle {
        id: rect

        anchors.fill: parent
        color: Config.clr.bg
        topRightRadius: Config.size.rounding
        bottomRightRadius: Config.size.rounding

        ColumnLayout {
          anchors.fill: parent

          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
              id: loader

              source: root.sectionComponents[root.activeSection]
              anchors.fill: parent
              anchors.margins: Config.spacing.leftBarPadding
            }
          }

          Item {
            Layout.fillWidth: true
            height: 48

            Column {
              anchors.fill: parent

              Rectangle {
                width: parent.width
                height: Config.size.borderWidth
                color: Config.clr.bgLt
                bottomRightRadius: Config.size.rounding
              }

              Row {
                height: parent.height - 4*2
                width: parent.width
                spacing: 4

                Repeater {
                  model: root.sectionComponents.length
                  delegate: Rectangle {
                    required property var modelData

                    height: parent.height
                    width: 32
                    color: "transparent"

                    MouseArea {
                      id: mouseArea

                      anchors.fill: parent
                      cursorShape: Qt.PointingHandCursor
                      hoverEnabled: true
                      onClicked: {
                        root.activeSection = modelData
                      }
                    }

                    Text {
                      anchors.centerIn: parent
                      text: root.sectionIcons[modelData]
                      font.pixelSize: Config.fontSize.icon
                      color: (mouseArea.containsMouse || modelData === root.activeSection) ? Config.clr.fg : Config.clr.bgLt
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  IpcHandler {
    target: "leftBar"

    function toggle(): void { ShellState.leftBar.show = !ShellState.leftBar.show }
  }
}
