// Store the current OSD message

import Quickshell
import QtQuick

pragma Singleton

Singleton {
  id: root

  signal textualOsd(osdText: string)

  function showOsd(text) {
    root.textualOsd(text)
  }
}
