// Network state

import Quickshell
import Quickshell.Networking
import QtQuick

pragma Singleton

Singleton {
  property var device: Networking.devices.values[0]
  property var networks: device?.networks
  property var activeNetwork: networks?.values.find((nw) => nw.connected)

  property string nwName: activeNetwork?.name ?? "N/A"
  property real nwSignal: (device?.type === DeviceType.Wifi) ? (activeNetwork?.signalStrength ?? 0) : 1
}
