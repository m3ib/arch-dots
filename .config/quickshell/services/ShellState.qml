// Short-term state of the shell, e.g. Workspaces is open/closed, Bar is collapsed
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  property var leftBar: QtObject {
    property bool show: false;
  }
  property var workspaces: QtObject {
    property bool show: false;
  }
}
