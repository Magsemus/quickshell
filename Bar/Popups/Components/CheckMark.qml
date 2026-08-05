import Quickshell
import QtQuick
import "../../../ColorSchemes"

Rectangle {
    id: outerBox

    Colorscheme { id: theme }

    property bool marked: false
    color: marked ? theme.colFg : "transparent"
    border.width: 2
    border.color: theme.colFg

    Text
    {
        id: checkMark

        width: parent.width
        height: parent.height
        color: "#000000"

        text: outerBox.marked ? "󰄬" : ""
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.family: theme.fontFamily
        font.pixelSize: 12
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            marked = !marked
        }
    }

    Behavior on color {
        ColorAnimation { duration: 200; }
    }
}
