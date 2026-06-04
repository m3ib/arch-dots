// Add defaults to the built-in Text
import QtQuick

import qs.services

Text {
  color: Config.clr.fg
  font.weight: Config.fontWeight.normal
  font.pixelSize: Config.fontSize.text
}
