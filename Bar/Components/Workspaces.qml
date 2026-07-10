import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick // for Text
import QtQuick.Layouts
import "../../ColorSchemes"

Item
{   
    id: root

    Colorscheme { id: theme }

    Rectangle
    {
        anchors.verticalCenter: parent.verticalCenter
        width: workspaceList.width + 30      
        height: workspaceList.height + 2
        radius: 12

        color: theme.colLightBlue

        Behavior on width {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuad }
        }

        ListView {
            id: workspaceList
                
            // 1. Define the model
            model: Hyprland.workspaces.values.filter(ws => ws.id > 0)

            // 2. Define the orientation (assumed horizontal based on most workspace bars)
            orientation: ListView.Horizontal
            spacing: 5 // Optional: adds space between your items

            height: 18
            implicitWidth: contentWidth
            anchors.centerIn: parent

            // Optional: interactive behavior
            interactive: false 

            // 3. Move the inner components into the delegate
            delegate: Text {

                property var ws: modelData
                // Note: 'index' is automatically available inside the delegate
                property bool isActive: Hyprland.focusedWorkspace?.id === ws.id

                text: ws.id
                color: isActive ? theme.colCyan : theme.colBlue
                font { pixelSize: 14; bold: true }
                renderType: Text.NativeRendering

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + " })")
                }
            }
        }
    }
}


