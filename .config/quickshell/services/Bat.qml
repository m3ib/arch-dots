// Battery state

import Quickshell
import Quickshell.Services.UPower
import QtQuick

pragma Singleton

Singleton {
  property var device: UPower.displayDevice
  property bool full: device.state == UPowerDeviceState.FullyCharged
  property bool charging: device.state == UPowerDeviceState.Charging
  property real percentage: Math.round(device.percentage*100)
  property real timeRemaining: charging ? device.timeToFull : device.timeToEmpty
}
