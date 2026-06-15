// A fullscreen overview of workspaces
// This module is strongly interlocked with hyprland's workspace rules

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services

ShellRoot {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: root

      required property var modelData

      // each monitor owns a range of workspaces, e.g. 1-100, 101-200, ...
      // each 10 workspaces in a monitor are grouped

      // count of workspaces in each monitor. need to be in-sync with hyprland
      readonly property real monWsCount: 100

      // the start itself is excluded
      property real monWsStart: Hyprland.monitors.values.find((mon) => mon.name == modelData.name)?.id * monWsCount
      // current workspace's group (in monitor)
      property real wsGroup: Math.floor((Hyprland.focusedWorkspace?.id - monWsStart - 1) / 10) * 10 // e.g. 0, 10, 20, ...

      screen: modelData
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
      anchors {
        top: true
        right: true
        bottom: true
        left: true
      }
      color: "transparent"
      focusable: true
      visible: ShellState.workspaces.show && (modelData.name == Hyprland.focusedMonitor.name)

      function getIcon(app) {
        return Quickshell.iconPath(app, DesktopEntries.heuristicLookup(app)?.icon)
      }

      function setWorkspace(value) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = "${value}" })`)
      }

      function shiftWorkspace(value) {
        // lock between the monitor workspaces range
        setWorkspace(Math.max(root.monWsStart+1, Math.min(Hyprland.focusedWorkspace.id+value,
        root.monWsStart+root.monWsCount)))
      }

      Item {
        focus: true
        Keys.onPressed: (event) => {
          // starts at zero
          const rowIndex = Math.floor((Hyprland.focusedWorkspace.id-1)/5);

          switch (event.key) {
            case Qt.Key_Return:
            case Qt.Key_Escape:
              ShellState.workspaces.show = false;
              event.accepted = true;
              break;
            case Qt.Key_H: // left-most workspace in row
              if (event.modifiers & Qt.ShiftModifier) {
                setWorkspace(rowIndex*5+1);
                event.accepted = true;
                break;
              }
            case Qt.Key_H: // left
              shiftWorkspace(-1);
              event.accepted = true;
              break;
            case Qt.Key_J: // next group
              if (event.modifiers & Qt.ShiftModifier) {
                shiftWorkspace(wsGrid.columns*wsGrid.rows);
                event.accepted = true;
                break;
              }
            case Qt.Key_J: // down
              shiftWorkspace(wsGrid.columns);
              event.accepted = true;
              break;
            case Qt.Key_K: // previous group
              if (event.modifiers & Qt.ShiftModifier) {
                shiftWorkspace(-wsGrid.columns*wsGrid.rows);
                event.accepted = true;
                break;
              }
            case Qt.Key_K: // up
              shiftWorkspace(-wsGrid.columns);
              event.accepted = true;
              break;
            case Qt.Key_L: // right-most workspace in row
              if (event.modifiers & Qt.ShiftModifier) {
                // find the last workspace in row, last maps to itself
                setWorkspace((rowIndex+1)*5);
                event.accepted = true;
                break;
              }
            case Qt.Key_L: // right
              shiftWorkspace(1);
              event.accepted = true;
              break;
            case Qt.Key_Home: // first workspace in the first group
              setWorkspace(root.monWsStart+1);
              event.accepted = true;
              break;
            case Qt.Key_End: // first workspace in the last group
              setWorkspace(root.monWsStart+monWsCount-9);
              event.accepted = true;
              break;
            default:
              event.accepted = true; // capture all other keys
          }
        }
      }

      // overlay
      Rectangle {
        anchors.fill: parent
        color: Config.clr.bg
        opacity: 0.8
      }

      // workspace groups
      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: (parent.height - wsGrid.height)/2 - height - 24
        spacing: 8

        Repeater {
          model: 10
          delegate: Rectangle {
            required property var modelData

            width: wsGroupTxt.width + Config.spacing.labelHPadding*2
            height: wsGroupTxt.height + Config.spacing.labelVPadding*2
            color: (modelData + 1 == Math.floor(root.wsGroup/10)+1) ? Config.clr.primary : Config.clr.bgLt
            radius: Config.size.rounding

            Behavior on color {
              ColorAnimation { duration: 150; easing.type: Easing.InOutQuad }
            }

            MouseArea {
              anchors.fill: parent
              onClicked: {
                setWorkspace(root.monWsStart+(modelData*10)+1) // first workspace in group
              }
            }

            Text {
              id: wsGroupTxt

              anchors.centerIn: parent
              text: "Group " + (modelData+1)
            }
          }
        }
      }

      GridLayout {
        id: wsGrid

        anchors.centerIn: parent
        rows: 2
        columns: 5
        rowSpacing: Config.spacing.wsGrid
        columnSpacing: Config.spacing.wsGrid

        Repeater {
          model: 10
          delegate: Rectangle {
            id: wsRect

            // calc. the optimal side length while preserving at least 1/2 an item worth of margin from screen edges
            required property var modelData

            property real length: Math.min(root.width/(wsGrid.columns+1), root.height/(wsGrid.rows+1))
            // workspace id used internally
            property real wsId: {parseInt(modelData)+root.monWsStart+root.wsGroup+1}
            property var workspace: Hyprland.workspaces.values.find((ws) => ws.id == wsRect.wsId && ws.monitor?.name == root.modelData.name)

            Layout.preferredWidth: length
            Layout.preferredHeight: length
            color: wsRect.workspace ? Config.clr.bgLt : Config.clr.bg
            radius: 8
            border.color: wsRect.wsId == Hyprland.focusedWorkspace?.id ? Config.clr.primary : "transparent"

            MouseArea {
              anchors.fill: parent
              onClicked: {
                setWorkspace(wsRect.wsId)
                ShellState.workspaces.show = false;
              }
            }

            Loader {
              active: !!wsRect.workspace
              sourceComponent: appGrid
              anchors.fill: parent
              anchors.margins: 32
            }

            Component {
              id: appGrid

              Grid {
                rows: 3
                columns: rows
                spacing: 2

                Repeater {
                  model: wsRect.workspace.toplevels
                  delegate: Image {
                    id: app

                    required property var modelData

                    width: parent.width/3
                    height: parent.height/3

                    source: getIcon(modelData.wayland?.appId)
                  }
                }
              }
            }

            // workspace id
            Rectangle {
              anchors.centerIn: parent
              color: Config.clr.bgLt
              width: 32
              height: width
              radius: height

              Text {
                anchors.centerIn: parent
                text: wsRect.modelData + 1
              }
            }
          }
        }
      }
    }
  }

  IpcHandler {
    target: "workspaces"

    function toggle(): void { ShellState.workspaces.show = !ShellState.workspaces.show }
  }
}
