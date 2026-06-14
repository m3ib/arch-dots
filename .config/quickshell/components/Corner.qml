// Ease hard corners

import QtQuick
import QtQuick.Shapes

import qs.services

Shape {
  id: root

  property real radius: Config.size.rounding
  property real angle: 0

  transform: Rotation { origin.x: root.radius/2; origin.y: root.radius/2; angle: root.angle}

  ShapePath {
    strokeWidth: 0
    strokeColor: "transparent"
    fillColor: Config.clr.bg
    startX: 0; startY: 0
    PathLine { x: 0;  y: root.radius }
    PathLine { x: root.radius; y: root.radius }
    PathArc {
      radiusX: root.radius
      radiusY: radiusX
      x: 0; y: 0
    }
  }
}
