import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../../ColorSchemes"

Rectangle 
{
    id: root

    property string labelText: ""
    property var onClickedAction: function () { console.log("No action defined") }

    width: 28
    height: 20
    radius: 16

    Colorscheme { id: theme } 

    color: mouseArea.containsPress ? theme.colClickBlue : (mouseArea.containsMouse ? theme.colHoverBlue : "transparent")

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Text
    {
        anchors.centerIn: parent
        text: root.labelText
        color: theme.colFg
        font { family: theme.fontFamily; pixelSize: 14; bold: true }
        renderType: Text.NativeRendering
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            root.onClickedAction()
        }
    }
}
