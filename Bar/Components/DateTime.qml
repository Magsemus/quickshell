import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../../ColorSchemes"

Text {
    id: dateText
    text: Qt.formatDateTime(new Date(), "MMM dd")
    color: theme.colBlue
    font { family: theme.fontFamily; pixelSize: 8; bold: true }
    renderType: Text.NativeRendering
}
