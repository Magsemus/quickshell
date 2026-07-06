import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick // for Text
import QtQuick.Layouts
import "../../ColorSchemes"

Repeater {
    Colorscheme { id: theme }
    property var activeWorkspaces: Hyprland.workspaces.values.filter(ws => ws.id > 0)

    model: activeWorkspaces

    Text {
        property var ws: modelData
        property bool isActive: Hyprland.focusedWorkspace?.id == ws.id
        text: ws.id
        color: isActive ? theme.colCyan : theme.colBlue
        font { pixelSize: 14; bold: true }
        renderType: Text.NativeRendering

        MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + " })")
        }
    }
}


