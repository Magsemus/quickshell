import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Bluetooth
import QtQuick.Controls
import "../../ColorSchemes"
import "./Components"
import "../Components/Base"

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
            color: "#BBBBBB"
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
                color: theme.colDarkFg
                font { family: theme.fontFamily; pixelSize: 14; bold: true }
                renderType: Text.NativeRendering

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
            }

            ToggleSwitch {
                id: enableToggle

                width: 45
                height: 20

                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter

                innerCircleColor: toggle ? theme.colToggleSwitchInnerCircle : theme.colFg
                
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
                color: theme.colDarkFg
                font { family: theme.fontFamily; pixelSize: 14; bold: true }
                renderType: Text.NativeRendering

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
            }

            ToggleSwitch {
                id: discorveringToggle

                width: 45
                height: 20

                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter

                innerCircleColor: toggle ? theme.colToggleSwitchInnerCircle : theme.colFg

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

        ListModel {
            id: validDevicesList
        }

        readonly property var deviceList: Bluetooth.defaultAdapter.devices.values

        property var checkDeviceList: () => {
            // 1. Add new valid devices
            for (let i = 0; i < deviceList.length; i++) {
                let rawDev = deviceList[i];
                if (!rawDev) continue;

                let cleanName = rawDev.name.replace(/[:-]/g, "");
                let cleanAddr = rawDev.address.replace(/[:-]/g, "");


                if (cleanName !== cleanAddr) {
                    // Check existence using ListModel.get()
                    let exists = false;
                    for (let j = 0; j < validDevicesList.count; j++) {
                        if (validDevicesList.get(j).device === rawDev) {
                            exists = true;
                            break;
                        }
                    }

                    if (!exists) {
                        // ListModel.append triggers native ListView 'add' transitions
                        validDevicesList.append({
                            name: rawDev.name,
                            icon: rawDev.icon,
                            device: rawDev,
                            isRemoving: false,
                        });
                        console.log(validDevicesList.count)
                    }
                }
            }

            // 2. Mark removed devices
            for (let i = 0; i < validDevicesList.count; i++) {
                let item = validDevicesList.get(i);
                if (!deviceList.includes(item.device) && !item.isRemoving) {
                    // Use setProperty to update roles inside a ListModel
                    validDevicesList.setProperty(i, "isRemoving", true);
                }
            }
        }

        onDeviceListChanged: {
            checkDeviceList();
        }

        function removeDevice(targetDevice) {
            // Loop backwards to remove safely by index
            for (let i = validDevicesList.count - 1; i >= 0; i--) {
                let item = validDevicesList.get(i);
                if (item.device === targetDevice || item === targetDevice || item.isRemoving === true) {
                    // ListModel.remove triggers native ListView 'remove' transitions
                    validDevicesList.remove(i);
                    break;
                }
            }
        }

        Text {
            id: deviceAmountText
            
            text: `${Bluetooth.defaultAdapter ? validDevicesList.count : 0} devices found`
            color: theme.colDarkerFg
            font { family: theme.fontFamily; pixelSize: 12; bold: false }
            renderType: Text.NativeRendering
            
            Layout.topMargin: 10
            Layout.leftMargin: 5
        }

        ScrollView {
            id: scrollView

            implicitWidth: 300
            implicitHeight: Math.min(scrollAnimatedList.contentHeight, 200) + 5
            Layout.leftMargin: 5

            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            clip: true
            

            AnimatedListView {
                id: scrollAnimatedList
                
                enableYAnimation: false
                orientation: ListView.Vertical
                spacing: 8

                Behavior on height {
                    NumberAnimation { duration: 250; easing.type: Easing.OutQuad }
                }

                Behavior on y {
                    NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
                }

                model: validDevicesList

                delegate: Row {

                    required property var modelData
                    spacing: 10

                    readonly property bool isConnected: modelData?.device?.connected ?? false
                    readonly property bool isPaired: modelData?.device?.paired ?? false 

                    height: 20

                    opacity: modelData.isRemoving ? 0 : 1
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }

                    onOpacityChanged: {
                        if (opacity <= 0 && modelData.isRemoving == true) {
                            bluetoothColumn.removeDevice(modelData)
                        }
                    }

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
                        color: theme.colToggleSwitchOn

                        font { family: theme.fontFamily; pixelSize: 18; bold: true }
                        renderType: Text.NativeRendering
                        elide: Text.ElideRight

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        width: isPaired ? 200 : 235
                        //Layout.maximumWidth: modelData.paired ? 220: 250

                        text: modelData.name
                        color: theme.colWhite

                        font { family: theme.fontFamily; pixelSize: 12; bold: true }
                        renderType: Text.NativeRendering
                        elide: Text.ElideRight

                        anchors.verticalCenter: parent.verticalCenter
                        Layout.alignment: Qt.AlignVCenter

                        Behavior on width {
                            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                        }
                    }

                    ServiceButton {
                        activeIcon: ""
                        anchors.verticalCenter: parent.verticalCenter
                        widthOffset: 10
                        heightOffset: 2
                        buttonRect.x: -1

                        textColor: isConnected ? theme.colBlack : theme.colWhite
                        backgroundColor: isConnected ? theme.colFg : "transparent"
                        hoverColor: isConnected ? theme.colDarkFg : theme.colHoverBlue
                        clickedColor: isConnected ? theme.colDarkerFg : theme.colClickBlue

                        onClickedAction: () => {
                            if (isConnected) {
                                modelData.device.disconnect()
                            }
                            else {
                                modelData.device.connect()
                            }
                        }

                        Behavior on x {
                            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                        }   

                    }

                    ServiceButton {
                        activeIcon: ""
                        centerVertically: false
                        textColor: hovering ? "#FFFFFF": theme.colWhite
                        hoverColor: Qt.rgba(0.85, 0, 0, 1)
                        visible: isPaired ? true : false

                        pixelSize: 18
                        widthOffset: 10
                        heightOffset: 2

                        textInCenter: false
                        textComponent.y: -2
                        textComponent.x: 4
                        buttonRect.y: -4.5

                        onClickedAction: () => {
                            if (Bluetooth.defaultAdapter) {
                                Bluetooth.defaultAdapter.removeDevice(modelData.device)
                            }
                        }
                    }

                    Behavior on y {
                        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                    }
                }   
            }

            Component.onCompleted: {
                if (Bluetooth.defaultAdapter) {
                    Bluetooth.defaultAdapter.discovering = true
                }
            }
        }

        Component.onCompleted: {
            checkDeviceList();
        }

        Behavior on height {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }
    }

    Behavior on height {
        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }
}
