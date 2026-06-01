// Short-term state of the shell, e.g. Workspaces is open/closed, Bar is collapsed

import Quickshell
import Quickshell.Io
import QtQuick

pragma Singleton

Singleton {
  property var workspaces: QtObject {
    property bool show: false;
  }
}
