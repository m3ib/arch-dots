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
  property var fontSize: QtObject {
    // in pixels
    property real text: 14
    property real icon: 16
  }
  property var fontWeight: QtObject {
    property real normal: 700
  }
  property var size: QtObject {
    property real bar: 32;
  }
  property var spacing: QtObject {
    // Global
    property real icon: 4 // icon-text gap
    // Bar.qml
    // hierarchy: bar>section>component
    property real barSection: 20; // section spacing
    property real barComp: 16; // component spacing
    property real barHPadding: 12; // horizontal padding
    property real barVPadding: 4; // vertical padding
    // Workspaces.qml
    property real wsGrid: 8; // spacing between each workspace
  }
}
