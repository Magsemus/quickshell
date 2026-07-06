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
                font { family: theme.fontFamily; pixelSize: 14; bold: true }
                renderType: Text.NativeRendering
                
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

                Rectangle
                {
                    Layout.rightMargin: 12
                    radius: 12

                    width: layoutRow.width + 20
                    height: layoutRow.height + 5
                    
                    
                    color: theme.colMuted

                    Row {
                        id: layoutRow
                        anchors.centerIn: parent
                        spacing: 10

                        DisplayCPU { id: cpu }
                        DisplayMemory { id: mem }
                        DisplayGPUTemp { id: gpu }
                    }
                }

                Timer {
                    interval: 2000
                    running: true
                    repeat: true
                    onTriggered: {
                        cpu.updateCpu()
                        mem.updateMem()
                        gpu.updateGpu()
                    }
                }
            }
        }
    }
}
