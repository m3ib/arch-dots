// Show notifications from NotifService

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick

import qs.components
import qs.services

ShellRoot {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData

      screen: modelData
      WlrLayershell.layer: WlrLayer.Overlay
      exclusionMode: ExclusionMode.Ignore
      visible: modelData.name == Hyprland.focusedMonitor?.name

      anchors {
        top: true
        right: true
        bottom: true
      }
      margins {
        top: Config.size.bar
      }

      implicitWidth: modelData.width
      color: "transparent"
      mask: Region { item: rect }

      Rectangle {
        id: rect

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Config.spacing.notifScreenGap
        anchors.rightMargin: Config.spacing.notifScreenGap

        width: Config.size.notifWidth
        height: NotifService.activeNotifs.length > 0 ? notifWrapper.implicitHeight : 0

        color: "transparent"

        visible: NotifService.activeNotifs.length > 0

        Column {
          id: notifWrapper

          anchors.top: parent.top
          width: parent.width

          visible: NotifService.activeNotifs.length > 0

          Loader {
            id: notifLoader

            active: NotifService.activeNotifs.length > 0
            sourceComponent: Notif {
              notif: {
                return NotifService.activeNotifs[0]}
            }
          }

          Connections {
            target: NotifService

            function onActiveNotifsChanged() {
              if (NotifService.activeNotifs.length == 0) {
                notifLoader.active = false;
              }

              if (notifLoader.item?.notif !== NotifService.activeNotifs[0]) {
                // force-update the loader
                notifLoader.active = false; notifLoader.active = true;
                return;
              }
            }
          }
        }

        Rectangle {
          width: 24
          height: width

          x: 0 - width/2
          visible: NotifService.activeNotifs.length > 1
          color: Config.clr.bg
          radius: height
          border.color: Config.clr.bgLt
          border.width: 2


          Text {
            id: notifCount

            anchors.centerIn: parent
            text: `+${NotifService.activeNotifs.length-1}`
            font.pixelSize: Config.fontSize.small
          }
        }
      }
    }
  }
}
