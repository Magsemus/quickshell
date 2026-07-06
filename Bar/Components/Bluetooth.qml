import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../../ColorSchemes"

Rectangle 
{
    id: bluetoothButton
    width: 28
    height: 20
    radius: 16

    Colorscheme { id: theme } 

    color: bluetoothMouseArea.containsPress ? theme.colClickBlue : (bluetoothMouseArea.containsMouse ? theme.colHoverBlue : "transparent")

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Text
    {
        anchors.centerIn: parent
        text: "󰂯"
        color: theme.colFg
        font { family: theme.fontFamily; pixelSize: 14; bold: true }
        renderType: Text.NativeRendering
    }

    MouseArea {
        id: bluetoothMouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            console.log("GIGGITY BLUETOOTH!")
        }
    }
}
