// A base component for all things clickable.
import QtQuick

Item {
  id: root

  property alias area: mouseArea

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
  }
}
