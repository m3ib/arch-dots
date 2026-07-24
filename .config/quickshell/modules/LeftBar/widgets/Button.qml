import QtQuick

import qs.components
import qs.services

Item {
  id: root

  property alias area: mouseArea
  property alias icon: iconText

  property color bg: Config.clr.primary

  width: Math.max(icon.width, icon.height) + 4*2
  height: width

  Rectangle {
    anchors.fill: parent
    color: root.bg
    radius: width
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
  }

  Text {
    id: iconText

    anchors.centerIn: parent
    text: ""
    font.pixelSize: Config.fontSize.icon
  }
}
