// A fullscreen overview of workspaces

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

      // e.g. wsGroup = 0, 10, 20, ...
      property real wsGroup: Math.floor((Hyprland.focusedWorkspace.id-1)/10)*10

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
        return Quickshell.iconPath(app, DesktopEntries.heuristicLookup(app).icon)
      }

      function setWorkspace(value) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = "${value}" })`)
      }

      function shiftWorkspace(value) {
        setWorkspace(Math.max(1, Hyprland.focusedWorkspace.id+value))
      }

      Item {
        focus: true
        Keys.onPressed: (event) => {
          switch (event.key) {
            case Qt.Key_Return:
            case Qt.Key_Escape:
              ShellState.workspaces.show = false;
              event.accepted = true;
              break;
            case Qt.Key_H: // left
              shiftWorkspace(-1)
              event.accepted = true;
              break;
            case Qt.Key_J: // down
              shiftWorkspace(wsGrid.columns)
              event.accepted = true;
              break;
            case Qt.Key_K: // up
              shiftWorkspace(-wsGrid.columns)
              event.accepted = true;
              break;
            case Qt.Key_L: // right
              shiftWorkspace(1)
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
            property real wsId: {parseInt(modelData)+1+root.wsGroup}
            property var workspace: Hyprland.workspaces.values.find((ws) => ws.id == wsRect.wsId)

            Layout.preferredWidth: length
            Layout.preferredHeight: length
            color: wsRect.workspace ? Config.clr.bgLt : Config.clr.bg
            radius: 8
            border.color: wsRect.wsId == Hyprland.focusedWorkspace.id ? Config.clr.primary : "transparent"

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

                    source: getIcon(modelData.wayland.appId)
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
                text: wsRect.wsId
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
