// Long-term static data used by the shell

import Quickshell
import QtQuick

pragma Singleton

Singleton {
  property var clr: QtObject {
    property string primary: "#6666EE";
    property string bg: "#13181E";
    property string bgLt: "#28323F";
    property string fg: "#F2F2F2";
  }
  property var size: QtObject {
    property real bar: 32;
  }
  property var spacing: QtObject {
    // bar > section > component
    property real barSection: 20; // section spacing
    property real barComp: 20; // component spacing
    property real barHPadding: 12; // horizontal padding
    property real barVPadding: 0; // vertical padding
  }
}
