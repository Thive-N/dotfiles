import QtQuick
import Quickshell

Item {
    id: dashboard
    width: 120
    height: parent.height

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: "#1e1e2e"

        Text {
            anchors.centerIn: parent
            text: "Dashboard"
            color: "white"
            font.pixelSize: 14
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                dashboardPopup.visible = !dashboardPopup.visible
            }
        }
    }

    Rectangle {
        id: dashboardPopup
        visible: false
        width: 400
        height: 300
        y: parent.height + 5
        radius: 10
        color: "#11111b"
    }
}
