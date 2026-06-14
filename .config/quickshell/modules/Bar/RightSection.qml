// The bar's right section

import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

import "widgets"

Item {
  visible: row.children.length > 0 // hide if empty

  Corner {
    anchors.top: parent.top
    x: parent.width - rect.width - width
    angle: 180
  }

  Rectangle {
    id: rect

    anchors.right: parent.right
    width: row.implicitWidth + Config.spacing.barHPadding*2
    height: parent.height
    bottomLeftRadius: Config.size.rounding
    color: Config.clr.bg

    RowLayout {
      id: row

      anchors.centerIn: parent
      height: parent.height - Config.spacing.barVPadding*2
      layoutDirection: Qt.RightToLeft
      spacing: Config.spacing.barComp

      Battery {}
      Network {}
    }
  }

  Corner {
    anchors.right: parent.right
    y: parent.height
    angle: 180
  }
}
