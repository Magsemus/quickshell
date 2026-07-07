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
    property bool clickAble: true

    width: 28
    height: 20
    radius: 16

    Colorscheme { id: theme } 

    color: clickAble ? (mouseArea.containsPress ? theme.colClickBlue : (mouseArea.containsMouse ? theme.colHoverBlue : "transparent")) : "transparent"

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
        
        onEntered: {
            if (!root.clickAble)
            {
                root.onClickedAction()
            }
        }

        onClicked: {
            if (root.clickAble)
            {
                root.onClickedAction()
            }
        }
    }
}
