// Long-term static data used by the shell

import Quickshell
import QtQuick

pragma Singleton

Singleton {
  property var clr: QtObject {
    property string primary: "#6666EE";
    property string bg: "#13181E";
    property string bgLt: "#28323F";
  }
  property var size: QtObject {
    property real bar: 32;
  }
}
