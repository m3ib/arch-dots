import QtQuick

import qs.components
import qs.services

Item {
  id: root

  implicitWidth: icon.width
  implicitHeight: icon.height

  MouseArea {
    anchors.fill: parent
    onClicked: Caffeine.toggle()
  }

  Text {
    id: icon

    anchors.centerIn: parent
    text: Caffeine.isRunning ? "󰅶" : "󰾪"
    color: Caffeine.isRunning ? Config.clr.fg : Config.clr.fgDrk
    font.pixelSize: Config.fontSize.icon
    anchors.verticalCenter: parent.verticalCenter

    Behavior on color {
      ColorAnimation { duration: Config.duration.animations; easing.type: Easing.InOutQuad }
    }
  }
}
