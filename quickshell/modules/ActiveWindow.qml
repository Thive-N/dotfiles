import QtQuick
import QtQuick.Layouts
import "." as Modules

Text {
    text: activeWindow
    color: Modules.Theme.purple
    font.pixelSize: Modules.Theme.fontSize
    font.family: Modules.Theme.fontFamily
    font.bold: true
    Layout.fillWidth: true
    elide: Text.ElideRight
    maximumLineCount: 1
}
