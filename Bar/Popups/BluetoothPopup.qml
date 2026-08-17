import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Bluetooth
import QtQuick.Controls
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

        Text {
            id: deviceAmountText
            
            text: `${Bluetooth.defaultAdapter ? validDeviceInt : 0} devices found`
            color: theme.colFg
            font { family: theme.fontFamily; pixelSize: 14; bold: true }
            renderType: Text.NativeRendering
            
            Layout.topMargin: 10
            Layout.leftMargin: 5

            readonly property var deviceList: Bluetooth.defaultAdapter.devices.values
            property int validDeviceInt: 0
            
            property var checkDeviceList: () => {
                validDeviceInt = 0;
                for (let i = 0 ; i < deviceList.length ; i++) {
                    let device = deviceList[i];
                    if (device.name.replace(/[:-]/g, "") != device.address.replace(/[:-]/g, "")) validDeviceInt++;
                }
            }

            onDeviceListChanged: {
                checkDeviceList();
            }

            Component.onCompleted: {
                checkDeviceList();
            }
        }

        ScrollView {
            id: scrollView

            implicitWidth: 300
            implicitHeight: (scrollColumn.height < 200) ? scrollColumn.height : 200
            Layout.leftMargin: 5

            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            clip: true
            

            ColumnLayout {
                id: scrollColumn
                spacing: 8

                // 2. Start discovering when loaded so nearby devices show up

                Repeater {
                    model: Bluetooth.defaultAdapter.devices.values


                    delegate: RowLayout {

                        required property var modelData
                        visible: modelData.name.replace(/[:-]/g, "") != modelData.address.replace(/[:-]/g, "") 
                        spacing: 4

                        function getGlyphIcon(iconName) {
                            if (!iconName) return "󰂯"; // Default Bluetooth symbol

                            if (iconName.includes("headset") || iconName.includes("headphones")) return "󰋋";
                            if (iconName.includes("speaker") || iconName.includes("audio")) return "󰓃";
                            if (iconName.includes("tv") || iconName.includes("display")) return "󰔁";
                            if (iconName.includes("phone")) return "󰄜";
                            if (iconName.includes("keyboard") || iconName.includes("mouse") || iconName.includes("input")) return "󰍽";

                            return "󰂯";
                        }

                        Text {
                            text: getGlyphIcon(modelData.icon)
                            color: theme.colFg
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 16
                        }

                        Text {
                            text: modelData.name
                            color: theme.colFg
                        }
                    }   
                }
            }

            Component.onCompleted: {
                if (Bluetooth.defaultAdapter) {
                    Bluetooth.defaultAdapter.discovering = true
                }
            }
        }
    }
}
