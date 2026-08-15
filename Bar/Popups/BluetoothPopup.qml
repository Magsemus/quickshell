import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Bluetooth
import "../../ColorSchemes"
import "./Components"

Item {
    id: bluetoothContainer

    width: bluetoothColumn.width
    height: bluetoothColumn.height + 10

    Colorscheme { id: theme }
    
    ColumnLayout {
        id: bluetoothColumn

        spacing: 5

        Text {
            id: bluetoothText
            text: "Bluetooth"
            color: theme.colFg
            font { family: theme.fontFamily; pixelSize: 14; bold: true }
            renderType: Text.NativeRendering
            Layout.topMargin: 10
            Layout.leftMargin: 5
        }

        Rectangle {
            id: enabledRect

            implicitWidth: (bluetoothContainer.width < 200) ? 200 : bluetoothContainer.width
            implicitHeight: bluetoothText.height + 2
            color: "transparent"

            Text {
                id: enableText
                text: "Enabled"
                color: theme.colFg
                font { family: theme.fontFamily; pixelSize: 14; bold: false }
                renderType: Text.NativeRendering

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
            }

            ToggleSwitch {
                id: enableToggle

                width: 50
                height: 20

                innerCircleColor: theme.colFg
                colorOff: theme.colBlack
                colorOn: theme.colHoverBlue
                
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                
                clickAction: () => {
                    toggle = !toggle
                    runProcess()
                }
                procAction: "bluetooth toggle"

                Connections {
                    target: Bluetooth.defaultAdapter
                    property var bluetoothStateCheck: () => {
                        if (Bluetooth.defaultAdapter) {
                            switch(Bluetooth.defaultAdapter.state) {
                                case 1: enableToggle.toggle = true; break;
                                case 4: enableToggle.toggle = false; break;
                            }
                        }
                    }
                    function onStateChanged() {
                        bluetoothStateCheck()
                    }
                    Component.onCompleted: {
                        bluetoothStateCheck()
                    }
                }
            }
        }

        Rectangle {
            id: discorveringRect

            implicitWidth: (bluetoothContainer.width < 200) ? 200 : bluetoothContainer.width
            implicitHeight: bluetoothText.height + 2
            color: "transparent"

            Text {
                id: discorveringText
                text: "Discorvering"
                color: theme.colFg
                font { family: theme.fontFamily; pixelSize: 14; bold: false }
                renderType: Text.NativeRendering

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
            }

            ToggleSwitch {
                id: discorveringToggle

                width: 50
                height: 20

                innerCircleColor: theme.colFg
                colorOff: theme.colBlack
                colorOn: theme.colHoverBlue

                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter

                clickAction: () => {
                    toggle = !toggle
                    if (Bluetooth.defaultAdapter) {
                        Bluetooth.defaultAdapter.discoverable = !Bluetooth.defaultAdapter.discoverable
                    }
                }

                Connections {
                    target: Bluetooth.defaultAdapter
                    property var bluetoothStateCheck: () => {
                        if (Bluetooth.defaultAdapter) {
                            if (Bluetooth.defaultAdapter.discoverable) discorveringToggle.toggle = true;
                            else discorveringToggle.toggle = false;
                        }
                    }
                    function onDiscoverableChanged() {
                        bluetoothStateCheck()
                    }
                    Component.onCompleted: {
                        bluetoothStateCheck()
                    }
                }
            }
        }
    }
}
