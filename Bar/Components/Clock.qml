import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../../ColorSchemes"

Text {
    id: clock
    text: Qt.formatDateTime(new Date(), "HH:mm")
    color: theme.colBlue
    font { family: theme.fontFamily; pixelSize: 9; bold: true }
    renderType: Text.NativeRendering
}
