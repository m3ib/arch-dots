// A notification component

import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

Rectangle {
  required property var notif

  // animation properties
  property real animX: 20
  property real animOpacity: 0.2

  width: Config.size.notifWidth
  height: mainContainer.implicitHeight + Config.spacing.notifVPadding*2
  color: Config.clr.bg
  radius: Config.size.rounding
  border.color: Config.clr.bgLt
  border.width: 2

  x: animX
  opacity: animOpacity

  Component.onCompleted: {
    x = 0
    opacity = 1
  }

  Behavior on x {
    NumberAnimation { duration: Config.duration.animations; easing.type: Easing.InOutQuad }
  }
  Behavior on opacity {
    NumberAnimation { duration: Config.duration.animations }
  }

  function expire() {
    NotifService.notifList.find((n) => n === notif).expired = true
  }

  Timer {
    running: true
    interval: notif.expireTimeout
    onTriggered: {
      expire()
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: expire()
  }

  ColumnLayout {
    id: mainContainer

    anchors.centerIn: parent
    width: parent.width - Config.spacing.notifHPadding*2
    spacing: 12

    RowLayout {
      Layout.fillWidth: true

      spacing: 8

      Image {
        property real imgSize: 32

        source: notif.image || (notif.appIcon.includes("/") ? notif.appIcon : Hypr.getIcon(notif.appIcon))
        Layout.preferredWidth: imgSize
        Layout.preferredHeight: imgSize
        sourceSize.width: imgSize
        sourceSize.height: imgSize
        smooth: true
        visible: !!notif.image || !!notif.appIcon
      }

      ColumnLayout {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignBottom

        Text {
          id: appName

          Layout.fillWidth: true
          text: notif.appName
          color: Config.clr.primary
          font.pixelSize: Config.fontSize.small
          font.weight: Config.fontWeight.light
        }

        Text {
          id: summary

          Layout.fillWidth: true
          text: notif.summary
          color: Config.clr.fgDrk
          font.pixelSize: Config.fontSize.small
          wrapMode: Text.Wrap
        }
      }
    }

    Text {
      id: body

      Layout.fillWidth: true
      color: Config.clr.fgDrk
      text: notif.body
      wrapMode: Text.Wrap
      font.weight: Config.fontWeight.light
    }

    // TODO: Load notif actions
  }
}
