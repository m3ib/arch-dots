// Hold system data & functions like time, cpu usage, ram, etc...

import Quickshell
import QtQuick

pragma Singleton

Singleton {
  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  function fmtTime(fmt) {
    return Qt.formatDateTime(clock.date, fmt)
  }
}
