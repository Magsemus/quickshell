import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../../ColorSchemes"

Rectangle 
{
    id: performanceButton
    width: 28
    height: 20
    radius: 16

    Colorscheme { id: theme } 

    color: performanceMouseArea.containsPress ? theme.colClickBlue : (performanceMouseArea.containsMouse ? theme.colHoverBlue : "transparent")

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Text
    {
        anchors.centerIn: parent
        text: ""
        color: theme.colFg
        font { family: theme.fontFamily; pixelSize: 14; bold: true }
        renderType: Text.NativeRendering
    }

    MouseArea {
        id: performanceMouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            console.log("GIGGITY PERFORMANCE!")
        }
    }
}
