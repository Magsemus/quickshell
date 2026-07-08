import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick // for Text
import QtQuick.Layouts
import "../ColorSchemes"
import "./Components"

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

            color: theme.colDarkBlue
            
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
                spacing: 0
                // Add your right-side elements here later (Clock, Battery, Volume, etc.)
                
                Tray { id: tray }

                Rectangle {
                    Layout.rightMargin: 3
                    Layout.leftMargin: 3
                    radius: 12
                    
                    width: clockRow.width + 20
                    height: clockRow.height
                    color: "transparent"

                    Row {
                        id: clockRow
                        anchors.centerIn: parent
                        spacing: 4
                        Text
                        {
                            text: "󰸘"
                            color: theme.colBlue
                            font { family: theme.fontFamily; pixelSize: 18; bold: true }
                            renderType: Text.NativeRendering
                        }

                        Column {
                            id: clockLayout
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: -1

                            Clock { 
                                id: clock 
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            DateTime { 
                                id: dateTime
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
                
                Rectangle
                {
                    Layout.rightMargin: 6
                    radius: 12

                    width: servicesLayoutRow.width + 10
                    height: servicesLayoutRow.height + 0
                    color: theme.colLightBlue

                    Row
                    {
                        id: servicesLayoutRow
                        anchors.centerIn: parent

                        Wifi { id: wifi }

                        ServiceButton { 
                            id: bluetooth
                            activeIcon: "󰂯"
                            onClickedAction: function () {
                                console.log("GIGGITY BLUETOOTH!")
                            }
                            clickAble: false
                        }

                        Power { id: performance }
                    }
                }

                Rectangle
                {
                    Layout.rightMargin: 24
                    radius: 12

                    width: layoutRow.width + 20
                    height: layoutRow.height + 5
                    color: theme.colLightBlue

                    Row {
                        id: layoutRow
                        anchors.centerIn: parent
                        spacing: 10

                        DisplayCPU { id: cpu }
                        DisplayMemory { id: mem }
                        DisplayGPUTemp { id: gpu }
                    }
                }

                ServiceButton { 
                    id: power 
                    activeIcon: ""
                    onClickedAction: function () {
                        console.log("GIGGITY POWER!")
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

                        var now = new Date()
                        clock.text = Qt.formatDateTime(now, "HH:mm")
                        dateTime.text = Qt.formatDateTime(now, "MMM dd")
                    }
                }
            }
        }
    }
}
