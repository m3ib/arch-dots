// Long-term static data used by the shell

import Quickshell
import QtQuick

pragma Singleton

Singleton {
  property var clr: QtObject {
    property color primary: "#6666EE";
    property color bg: "#13181E";
    property color bgLt: "#28323F";
    property color fg: "#F2F2F2";
    property color danger: "#F38BA8";
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
