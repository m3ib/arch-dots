// The bar's center section

import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services


Item {
  id: root

  property var monitor

  width: rect.width
  visible: row.children.length > 0 // hide if empty

  Corner {
    anchors.top: parent.top
    x: -width
    angle: 180
  }

  Rectangle {
    id: rect

    width: row.implicitWidth + Config.spacing.barHPadding*2
    height: parent.height
    bottomRightRadius: Config.size.rounding
    bottomLeftRadius: Config.size.rounding
    color: Config.clr.bg

    Behavior on width {
      NumberAnimation { duration: Config.duration.animations; easing.type: Easing.InOutQuad }
    }
  }

  RowLayout {
    id: row

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: Config.spacing.barHPadding
    height: parent.height - Config.spacing.barVPadding*2
    spacing: Config.spacing.barComp

    // TODO: add content
  }

  Corner {
    anchors.top: parent.top
    x: rect.width
    angle: 90
  }
}
