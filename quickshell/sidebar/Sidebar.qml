import "../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Scope {
    id: root

    property string time

    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 20
        color: Theme.colBg

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                color: Theme.colBlue
                text: root.time
            }
        }
    }
    PanelWindow {
        implicitWidth: 20
        color: Theme.colBg

        anchors {
            top: true
            left: true
            bottom: true
        }

        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 8

            Repeater {
                model: 9

                Rectangle {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 20
                    color: "transparent"

                    property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    property bool hasWindows: workspace !== null

                    Text {
                        text: index + 1
                        color: parent.isActive ? Theme.colPurple : (parent.hasWindows ? Theme.colCyan : Theme.colMuted)
                        font.pixelSize: Theme.fontSize
                        font.family: Theme.fontFamily
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    }
                }
            }
        }
    }

    Process {
        id: dateProc

        command: ["date"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.time = this.text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
