// Contains all variants of ProgressOsd

import Quickshell
import QtQuick

import qs.components
import qs.services

import "widgets"

Item {
  id: root

  width: row.implicitWidth
  height: 250

  Row {
    id: row

    anchors.centerIn: parent
    height: parent.height
    spacing: 8

    BrightnessOsd {}
    VolumeOsd {}
  }
}
