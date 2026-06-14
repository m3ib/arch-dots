// The bar's left section

import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services


Item {
  visible: row.children.length > 0 // hide if empty

  Corner {
    anchors.left: parent.left
    y: parent.height
    angle: 90
  }

  Rectangle {
    id: rect

    anchors.left: parent.left
    width: row.implicitWidth + Config.spacing.barHPadding*2
    height: parent.height
    bottomRightRadius: Config.size.rounding
    color: Config.clr.bg

    RowLayout {
      id: row

      anchors.centerIn: parent
      height: parent.height - Config.spacing.barVPadding*2
      spacing: Config.spacing.barComp

      Text {
        id: clock

        color: Config.clr.fg
        text: Sys.fmtTime("hh:mm")
      }
    }
  }

  Corner {
    anchors.top: parent.top
    x: rect.width
    angle: 90
  }
}
