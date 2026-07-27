// The bar's left section

import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

import "./widgets/"

Item {
  id: root

  property var monitor
  property bool leftBarOpen: (ShellState.leftBar.show && Hypr.isFocusedMonitor(monitor?.name))

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
    bottomRightRadius: root.leftBarOpen ? 0 : Config.size.rounding
    color: Config.clr.bg

    Behavior on width {
      NumberAnimation { duration: Config.duration.animations; easing.type: Easing.InOutQuad }
    }
  }

  RowLayout {
    id: row

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: Config.spacing.barHPadding
    height: parent.height - Config.spacing.barVPadding*2
    spacing: Config.spacing.barComp

    Text {
      id: clock

      text: Clock.fmtTime("hh:mm")
    }

    Stopwatch {}
  }

  Corner {
    anchors.top: parent.top
    x: rect.width
    angle: 90
  }

  Corner {
    anchors.bottom: parent.bottom
    x: rect.width
    angle: 0
    visible: root.leftBarOpen
  }
}
