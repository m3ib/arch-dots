// The bar's center section

import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services


Item {
  id: root

  property var monitor

  property bool shouldShow: !Hypr.isFullscreenMonitor(monitor?.name) && row.children.length > 0

  width: rect.width
  visible: shouldShow

  Behavior on opacity {
    NumberAnimation { duration: Config.duration.animations }
  }

  onShouldShowChanged: {
    if (!shouldShow)
      animTimer.running = true
     else {
      root.visible = true
    }
    root.opacity = shouldShow ? 1 : 0
  }

  Timer {
    id: animTimer

    interval: Config.duration.animations
    onTriggered: {
      root.visible = root.shouldShow
    }
  }

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
