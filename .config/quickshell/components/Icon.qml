// Add defaults to the built-in Text
import QtQuick

import qs.services

Text {
  property bool large: false

  color: Config.clr.fg
  font.weight: Config.fontWeight.normal
  font.pixelSize: large ? Config.fontSize.iconL : Config.fontSize.icon
  font.family: Config.fontFamily.icon
}
