// Long-term static data used by the shell

import Quickshell
import QtQuick

pragma Singleton

Singleton {
  property var clr: QtObject {
    property color primary: "#6666EE";
    property color primaryLt: "#8C8CF1";
    property color bg: "#13181E";
    property color bgLt: "#28323F";
    property color fg: "#F2F2F2";
    property color fgDrk: "#B2B2B2";
    property color danger: "#EC6990";
    property color success: "#69EC90";
  }

  property var fontSize: QtObject {
    // in pixels
    property real small: 12;
    property real text: 14;
    property real heading: 18;
    property real icon: 16;
    property real iconL: 24;
  }

  property var fontWeight: QtObject {
    property real light: 500;
    property real normal: 700;
    property real bold: 900;
  }

  property var size: QtObject {
    // Global
    property real rounding: 10;
    property real borderWidth: 2;

    property real bar: 32;
  }

  property var spacing: QtObject {
    // Global
    property real icon: 4; // icon-text gap
    property real labelHPadding: 12;
    property real labelVPadding: 8;

    // Bar module
    // hierarchy: bar>section>component
    property real barSection: 20; // section spacing
    property real barComp: 16; // component spacing
    property real barHPadding: 12; // horizontal padding
    property real barVPadding: 4; // vertical padding

    // LeftBar module
    property real leftBarPadding: 12

    // Workspaces module
    property real wsGrid: 8; // spacing between each workspace

    // Osd module
    property real osdScreenGap: 48;
    property real osdHPadding: 16;
    property real osdVPadding: 12;
    property real progressOsdPadding: 4;
  }

  property var duration: QtObject {
    // in milliseconds
    property real animations: 150;
    property real osd: 2000;
  }
}
