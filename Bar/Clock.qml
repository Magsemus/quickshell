import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../ColorSchemes"

Text {
    id: clock
    text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
    color: theme.colYellow
    font { family: theme.fontFamily; pixelSize: theme.fontSize; bold: true }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
        }
    }
}
