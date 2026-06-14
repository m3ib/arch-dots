import Quickshell
import QtQuick

import qs.components
import qs.services

Item {
  id: root

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  property color clr: Bat.percentage > 25 ? Config.clr.fg : Config.clr.danger

  function getBatIcon() {
    const icons = {
      95: {"charging": "󰂅", "normal": "󰁹"},
      90: {"charging": "󰂋", "normal": "󰂂"},
      80: {"charging": "󰂊", "normal": "󰂁"},
      70: {"charging": "󰢞", "normal": "󰂀"},
      60: {"charging": "󰂉", "normal": "󰁿"},
      50: {"charging": "󰢝", "normal": "󰁾"},
      40: {"charging": "󰂈", "normal": "󰁽"},
      30: {"charging": "󰂇", "normal": "󰁼"},
      20: {"charging": "󰂆", "normal": "󰁻"},
      10: {"charging": "󰢜", "normal": "󰁺"},
      0:  {"charging": "󰢟", "normal": "󰂎"},
    }

    if (Bat.full) {
      return "󱟢"
    }

    for (const i of Object.keys(icons).map(Number).sort((a, b) => b - a)) {
      if (Bat.percentage < i) {
        continue
      }
      return Bat.charging ? icons[i].charging : icons[i].normal
    }
  }

  Row {
    id: row

    spacing: Config.spacing.icon

    Text {
      id: icon

      anchors.verticalCenter: parent.verticalCenter

      text: getBatIcon()
      font.pixelSize: Config.fontSize.icon
      color: root.clr
    }

    Text {
      id: txt

      anchors.verticalCenter: parent.verticalCenter

      text: Bat.percentage + "%"
      color: root.clr
    }
  }
}
