import QtQuick

import qs.components
import qs.services

Item {
  id: root

  property alias area: mouseArea
  property alias body: iconText

  property color bg: Config.clr.primary

  width: Config.size.button
  height: Config.size.button

  Rectangle {
    id: rect

    anchors.fill: parent
    color: root.bg
    radius: Config.size.rounding
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
  }

  Icon {
    id: iconText

    anchors.centerIn: parent
    text: ""
  }
}
