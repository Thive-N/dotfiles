import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland
import "." as Modules

Item {
    id: hyprlandInfo
    anchors.fill: parent
    property string activeWindow: "Window"
    property string currentLayout: "Tile"
    // Active window title
    Process {
        id: windowProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.title // empty'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    hyprlandInfo.activeWindow = data.trim();
                }
            }
        }
        Component.onCompleted: running = true
    }

    // Current layout (Hyprland: dwindle/master/floating)
    Process {
        id: layoutProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .floating then \"Floating\" elif .fullscreen == 1 then \"Fullscreen\" else \"Tiled\" end'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    hyprlandInfo.currentLayout = data.trim();
                }
            }
        }
        Component.onCompleted: running = true
    }

    // Event-based updates for window/layout (instant)
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            windowProc.running = true;
            layoutProc.running = true;
        }
    }

    // Backup timer for window/layout (catches edge cases)
    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            windowProc.running = true;
            layoutProc.running = true;
        }
    }
    RowLayout {
        anchors.fill: parent
        Repeater {
            model: 9

            Rectangle {
                Layout.preferredWidth: 20
                Layout.preferredHeight: parent.height
                color: "transparent"

                property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                property bool hasWindows: workspace !== null

                Text {
                    text: index + 1
                    color: parent.isActive ? Modules.Theme.colCyan : (parent.hasWindows ? Modules.Theme.colCyan : Modules.Theme.colMuted)
                    font.pixelSize: Modules.Theme.fontSize
                    font.family: Modules.Theme.fontFamily
                    font.bold: true
                    anchors.centerIn: parent
                }

                Rectangle {
                    width: 20
                    height: 3
                    color: parent.isActive ? Modules.Theme.colPurple : Modules.Theme.colBg
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            color: Modules.Theme.colMuted
        }
        Text {
            text: hyprlandInfo.currentLayout
            color: Modules.Theme.colFg
            font.pixelSize: Modules.Theme.fontSize
            font.family: Modules.Theme.fontFamily
            font.bold: true
            Layout.leftMargin: 5
            Layout.rightMargin: 5
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 2
            Layout.rightMargin: 8
            color: Modules.Theme.colMuted
        }

        // center
        Text {
            text: hyprlandInfo.activeWindow
            color: Modules.Theme.colPurple
            font.pixelSize: Modules.Theme.fontSize
            font.family: Modules.Theme.fontFamily
            font.bold: true
            Layout.fillWidth: true
            Layout.leftMargin: 8
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }
}
