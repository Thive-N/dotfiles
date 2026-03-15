import Quickshell
import QtQuick
import QtQuick.Layouts
import "./modules" as Modules

ShellRoot {
    id: root
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30
            color: Modules.Theme.colBg

            Rectangle {
                anchors.fill: parent
                color: Modules.Theme.colBg

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Modules.HyprlandInfo {}
                    Modules.SystemInfo {}
                }
            }
        }
    }
}
