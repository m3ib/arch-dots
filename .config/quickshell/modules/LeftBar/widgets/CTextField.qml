import QtQuick
import QtQuick.Controls

import qs.services

TextField {
  id: control

  color: Config.clr.fg
  font.pixelSize: Config.fontSize.text
  font.weight: Config.fontWeight.bold
  horizontalAlignment: TextInput.AlignHCenter
  background: Rectangle {
    implicitWidth: 200
    implicitHeight: 40
    color: "transparent"
    border.width: Config.size.borderWidth
    border.color: control.hovered ? Config.clr.primary : "transparent"
    radius: Config.size.rounding
  }
}
