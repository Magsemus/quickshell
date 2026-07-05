import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick // for Text
import QtQuick.Layouts
import "../ColorSchemes"

Scope {

    Colorscheme { id: theme}

    PanelWindow {
        id: panelBar
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 30
        color: "transparent"

        Rectangle 
        {
            id: backgroundRect
            anchors.fill: parent
            anchors.margins: 1

            radius: 12

            color: theme.colBg
            
            RowLayout {
                id: leftSection
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 12

                Workspaces {}
            }

            Text 
            {
                anchors.centerIn: parent
                width: parent.width * 0.2

                text: Hyprland.activeToplevel ? (Hyprland.activeToplevel.title || "Window") : ""

                color: theme.colFg
                font { family: theme.fontFamily; pixelSize: theme.fontSize; bold: true }
                
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }


            RowLayout {
                id: rightSection
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 12
                spacing: 16
                // Add your right-side elements here later (Clock, Battery, Volume, etc.)
                Clock { id: clock }
                DisplayCPU { id: cpu }
                DisplayMemory { id: mem }

                Timer {
                    interval: 2000
                    running: true
                    repeat: true
                    onTriggered: {
                        cpu.updateCpu()
                        mem.updateMem()
                        clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                    }
                }
            }
        }
    }
}
