import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.components
import qs.services

import "./widgets/"

Item {
  id: root

  anchors.fill: parent

  ColumnLayout {
    anchors.fill: parent
    spacing: 24

    Column {
      Layout.alignment: Qt.AlignHCenter

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Clock.fmtTime("hh:mm:ss")
        font.pixelSize: Config.fontSize.heading
      }

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Clock.fmtTime(`ddd, MMM dd'${Clock.ordinalSuffix(Number(Clock.fmtTime('dd')))}' M/yy`)
        color: Config.clr.fgDrk
        font.weight: Config.fontWeight.light
      }
    }

    Column {
      Layout.fillWidth: true
      spacing: 12

      Text {
        text: "Set up"
        color: Config.clr.primaryLt
        font.pixelSize: Config.fontSize.small
      }

      Rectangle {
        width: parent.width
        height: stopwatchContainer.height + 8*2
        color: Config.clr.bgLt
        radius: Config.size.rounding

        ColumnLayout {
          id: stopwatchContainer

          anchors.centerIn: parent
          width: parent.width - 8*2
          spacing: 4

          Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Stopwatch"
            color: Config.clr.fgDrk
            font.weight: Config.fontWeight.light
          }

          Text {
            Layout.alignment: Qt.AlignHCenter
            text: Clock.fmtDuration(Clock.stopwatch)
            font.pixelSize: Config.fontSize.heading
          }

          Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4

            Button {
              visible: !Clock.stopwatchRunning && Clock.stopwatch !== 0

              bg: Config.clr.bg
              area.onClicked: Clock.resetStopwatch()
              icon.text: "󰑓"
            }

            Button {
              area.onClicked: Clock.toggleStopwatch()
              icon.text: Clock.stopwatchRunning ? "" : ""
            }
          }
        }
      }

      Rectangle {
        width: parent.width
        height: timerContainer.height + 8*2
        color: Config.clr.bgLt
        radius: Config.size.rounding

        ColumnLayout {
          id: timerContainer

          anchors.centerIn: parent
          width: parent.width - 8*2
          spacing: 4

          Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Timer"
            color: Config.clr.fgDrk
            font.weight: Config.fontWeight.light
          }

          CTextField {
            id: timerTitleField

            Layout.alignment: Qt.AlignHCenter
            placeholderText: "Eggs"
          }

          CTextField {
            id: timerDurationField

            Layout.alignment: Qt.AlignHCenter
            placeholderText: "8m 30s"

            onAccepted: {
              Clock.createTimer(timerTitleField.text, Clock.parseDuration(timerDurationField.text))
              timerTitleField.text = "";
              timerDurationField.text = "";
            }
          }
        }
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 8

      Text {
        text: "Ongoing"
        color: Config.clr.primaryLt
        font.pixelSize: Config.fontSize.small
      }

      Column {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 8

        Repeater {
          model: Clock.timersModel
          delegate: Rectangle {
            required property var modelData
            property bool isTimerPositive: modelData.timeLeft >= 0

            width: parent.width
            height: ongoingTimerCol.height + 16*2
            color: Config.clr.bgLt
            radius: Config.size.rounding

            ColumnLayout {
              id: ongoingTimerCol
              anchors.centerIn: parent
              width: parent.width - 8*2
              spacing: 4

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: modelData.title
                color: Config.clr.fgDrk
                font.weight: Config.fontWeight.light
              }

              Text {
                Layout.alignment: Qt.AlignHCenter
                text: (isTimerPositive ? "" : "-") + Clock.fmtDuration(modelData.timeLeft)
                color: isTimerPositive ? Config.clr.fg : Config.clr.danger
                font.pixelSize: Config.fontSize.heading
              }

              Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Button {
                  visible: !modelData.running

                  bg: Config.clr.bg
                  area.onClicked: Clock.resetTimer(modelData.id)
                  icon.text: "󰑓"
                }

                Button {
                  area.onClicked: Clock.toggleTimer(modelData.id)
                  icon.text: modelData.running ? "" : ""
                }

                Button {
                  visible: !modelData.running

                  bg: Config.clr.bg
                  area.onClicked: Clock.removeTimer(modelData.id)
                  icon.text: ""
                }
              }
            }
          }
        }
      }
    }
  }
}
