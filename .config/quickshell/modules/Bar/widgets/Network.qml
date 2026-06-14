import Quickshell
import QtQuick

import qs.components
import qs.services

Item {
  id: root

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  function getWifiIcon() {
    if (Networking.activeNetwork == null) {
      return "󰤮"
    }

    if (Networking.activeNetwork.stateChanging) {
      return "󰤫"
    }

    if (Networking.nwSignal > 0.8) {
      return "󰤨"
    } else if (Networking.nwSignal > 0.6) {
      return "󰤥"
    } else if (Networking.nwSignal > 0.4) {
      return "󰤢"
    } else if (Networking.nwSignal > 0.2) {
      return "󰤟"
    } else {
      return "󰤯"
    }
  }

  Row {
    id: row

    spacing: Config.spacing.icon

    Text {
      id: icon

      text: getWifiIcon()
      font.pixelSize: Config.fontSize.icon
      anchors.verticalCenter: parent.verticalCenter
    }

    Text {
      id: txt

      text: Networking.nwName
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}
