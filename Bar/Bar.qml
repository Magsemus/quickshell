import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects
import Quickshell.Bluetooth
import "../ColorSchemes"
import "./Components"
import "./Components/Base"
import "./Utils"
import "./Popups"


Rectangle 
{
    id: backgroundRect

    Colorscheme { id: theme }

    //anchors.margins: 0.232
    //anchors.topMargin: 20
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: + 10
    
    width: parent.width - 35
    height: 35
    radius: 12

    gradient: Gradient {
        orientation: Gradient.vertical
        GradientStop { position: 1.0; color: theme.colDarkBlue } // Orange
        GradientStop { position: 0.0; color: "#110d11"} // Yellow
    }

    property PanelWindow mainWindow 
    property BarWidget middleWidget 
    property BarWidget servicePopup
    property Item serviceMouseArea

    MultiEffect {
        anchors.fill: backgroundRect
        source: backgroundRect
        
        shadowEnabled: true
        shadowColor: theme.colDarkBlue // Light pink glow matching wallpaper
        shadowBlur: 0.1 // Blur intensity
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 1
    }

    RowLayout {
        id: leftSection
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 12

        Image
        {
            Layout.rightMargin: 5
            source: Icons.getArchIcon()
        }

        Workspaces {}
    }

    Rectangle
    {
        id: rectTitle
        anchors.centerIn: parent
        width: Math.min(title.implicitWidth + 20, backgroundRect.width * 0.2 + 20)                
        height: title.height
        radius: 12

        Behavior on width {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }   

        color: theme.colDarkBlue

        Text 
        {
            id: title
            anchors.centerIn: parent
            width: backgroundRect.width * 0.2

            color: theme.colFg
            font { family: theme.fontFamily; pixelSize: 14; bold: true }
            renderType: Text.NativeRendering

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            readonly property string realTitle: Hyprland.activeToplevel ? (Hyprland.activeToplevel.title || "Window") : "  Desktop"

            Component.onCompleted: text = realTitle

            onRealTitleChanged: deferTimer.restart()

            Timer {
                id: deferTimer
                interval: 50 // A tiny 50ms buffer to let Hyprland's IPC catch up
                repeat: false
                onTriggered: {
                    if (fadeSequence.running) fadeSequence.stop()
                    fadeSequence.start()
                }
            }

            SequentialAnimation {
                id: fadeSequence

                // Step A: Shrink the old icon down to nothing
                NumberAnimation { 
                    target: title; property: "opacity"
                    to: 0; duration: 200; easing.type: Easing.InQuad 
                }

                PropertyAction { 
                    target: title
                    property: "text"
                    value: title.realTitle 
                }
                // Step C: Pop it back up to full size with the spring effect
                NumberAnimation { 
                    target: title; property: "opacity"
                    to: 1; duration: 220; easing.type: Easing.OutQuad
                }
            }
        }
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
            id: serviceScriptButtonRect

            Layout.rightMargin: 6
            radius: 6

            width: servicesLayoutRow.width + 20
            height: servicesLayoutRow.height + 2

            color: theme.colLightBlue

            Layout.alignment: Qt.AlignVCenter

            RowLayout
            {
                id: servicesLayoutRow
                anchors.centerIn: parent
                spacing: 10
    
                ServicePopupButton {
                    id: wifi

                    content: "WifiPopup"
                    servicePopup: backgroundRect.servicePopup
                    serviceMouseArea: backgroundRect.serviceMouseArea

                    scriptPath: "/home/magse/.config/quickshell/Bar/Scripts/wifi_stream.sh"
                    procAction: function(line) {
                        let cleanLine = line.trim();
                        let parts = cleanLine.split(" ")

                        let status = parts[0]
                        let strength = parseInt(parts[1])

                        let targetIcon = "󰤮";
                        if (status != "disconnected") 
                        {
                            if (strength > 80) targetIcon = "󰤨";      
                            else if (strength > 60) targetIcon = "󰤥"; 
                            else if (strength > 40) targetIcon = "󰤢"; 
                            else if (strength > 20) targetIcon = "󰤟";
                            else targetIcon = "󰤯"
                        }
                        triggerIconUpdate(targetIcon);
                    }
                    textIcon: "󰤯"
                    buttonAnimationType: "fade"
                    anchors.verticalCenter: parent.verticalCenter
                }

                ServicePopupButton {
                    id: bluetooth

                    content: "BluetoothPopup"
                    servicePopup: backgroundRect.servicePopup
                    serviceMouseArea: backgroundRect.serviceMouseArea

                    textIcon: "󰂯"
                    buttonAnimationType: "fade"
                    anchors.verticalCenter: parent.verticalCenter

                    Connections {
                        id: bluetoothConnection
                        target: Bluetooth.defaultAdapter

                        property var bluetoothStateCheck: () => {
                            console.log("does bluetooth defaultAdapter exist? " + Bluetooth.defaultAdapter)
                            if (Bluetooth.defaultAdapter) {
                                switch(Bluetooth.defaultAdapter.state) {
                                    case 1: bluetooth.triggerIconUpdate("󰂯"); break;
                                    case 4: bluetooth.triggerIconUpdate("󰂲"); break;
                                }
                            }
                        }

                        function onStateChanged() {
                            bluetoothStateCheck()
                        }
                        
                    }

                    Process {
                        command: ["bluetooth"]
                        running: true

                        stdout: SplitParser {
                            onRead: (line) => {
                                if (line.includes("on")) bluetooth.textIcon = "󰂯";  
                                else if (line.includes("off")) bluetooth.textIcon = "󰂲"; 
                            }
                        }
                    }
                }

                ServicePopupButton {
                    id: powerProfile

                    content: "PowerProfilesPopup"
                    servicePopup: backgroundRect.servicePopup
                    serviceMouseArea: backgroundRect.serviceMouseArea

                    scriptPath: "/home/magse/.config/quickshell/Bar/Scripts/power_stream.sh"
                    procAction: function(line) {
                        let cleanLine = line.trim();
                        triggerIconUpdate(cleanLine);
                    }

                    textIcon: ""
                    anchors.verticalCenter: parent.verticalCenter
                    scriptButton.serviceButton.height: 19
                    scriptButton.serviceButton.width: 14
                    
                }
            }
        }

        Rectangle
        {
            Layout.rightMargin: rightSection.batteryConnected ? 64 : 24
            radius: 6

            width: layoutRow.width + 20
            height: layoutRow.height + 5

            color: theme.colLightBlue
            
            Behavior on width{
                NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
            }

            Row {
                id: layoutRow
                anchors.centerIn: parent
                spacing: 10


                DiagnosticText {
                    id: cpu
                    text: "󰓅 " + value + "%"
                    parseData: function(data) {
                        if (!data) return
                        var p = data.trim().split(/\s+/)
                        var idle = parseInt(p[4]) + parseInt(p[5])
                        var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)

                        var result = value
                        if (value2 > 0) {
                            result = Math.round(100 * (1 - (idle - value3) / (total - value2)))
                        }

                        value2 = total
                        value3 = idle
                        return result
                    }
                    procCommand: "head -1 /proc/stat"
                }
                DiagnosticText { 
                    id: mem 
                    text: "󰍛 " + value + "%"
                    parseData: function(data) {
                        if (!data) return
                        var parts = data.trim().split(/\s+/)
                        var total = parseInt(parts[1]) || 1
                        var used = parseInt(parts[2]) || 0
                        return Math.round(100 * used / total)
                    }
                    procCommand: "free | grep Mem"
                }
                DiagnosticText { 
                    id: gpu
                    text: " " + value + "°C"
                    parseData: function(data) {
                        if (!data) return
                        return data
                    }
                    procCommand: rightSection.amdGraphicsCard ? "echo \"$(( $(cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input) / 1000 ))\"" : "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits"
                }
                DiagnosticText { 
                    id: battery
                    text: rightSection.batteryConnected ? `${icon} ${value}%` : ""
                    parseData: function(data) {
                        if (!data) return

                        if (String(data) == "Discharging" || String(data) == "Not charging") {
                            charging = false
                            return battery.value
                        }
                        if (String(data) == "Charging") {
                            charging = true
                            return battery.value
                        }

                        const discharginIcons = ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
                        const chargingIcons = ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]

                        let iconNumber = data
                        let i = 0
                        while (iconNumber >= 10 && i < chargingIcons.length) {
                            iconNumber = iconNumber - 10
                            i++
                        }

                        icon = charging ? chargingIcons[i] : discharginIcons[i]
                        return data
                    }
                    procCommand: "cat /sys/class/power_supply/BAT0/status /sys/class/power_supply/BAT0/capacity"
                    property string icon: "󰂎"
                    property bool charging: false
                }
            }
        }

        ServiceButton { 
            id: power 
            activeIcon: ""
            onClickedAction: function () {
                if (middleWidget.contentLoader.source != "../../Popups/PowerPopup.qml") 
                { 
                    middleWidget.contentLoader.source = "../../Popups/PowerPopup.qml"
                }
                else 
                {
                    middleWidget.contentLoader.source = ""
                }
            }
            isCircle: true
            buttonRect.x: -0.5
            widthOffset: 10
            Layout.alignment: Qt.AlignVCenter
        }

        property bool batteryConnected: false
            
        Process {
            id: batteryCheck
            command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/present 2>/dev/null || echo 'No battery'"]

            running: true

            // 2. Capture standard output
            stdout: StdioCollector {
                onStreamFinished: {
                    let output = text.trim()

                    if (output === "1") {
                        rightSection.batteryConnected = true
                    } else {
                        rightSection.batteryConnected = false
                    }
                }
            }
        }
        
        property bool amdGraphicsCard: false

        Process {
            id: graphicsCardTypeCheck
            command: ["bash", "-c", "lspci | grep -E \"VGA|3D|Display\""]

            running: true

            stdout: StdioCollector {
                onStreamFinished: {
                    let output = text.trim()

                    if (output.includes("AMD")) {
                        rightSection.amdGraphicsCard = true
                    }
                    else {
                        rightSection.amdGraphicsCard = false
                    }
                }
            }
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            onTriggered: {
                cpu.update()
                mem.update()
                gpu.update()
                if (rightSection.batteryConnected) {
                    battery.update()
                }

                var now = new Date()
                clock.text = Qt.formatDateTime(now, "HH:mm")
                dateTime.text = Qt.formatDateTime(now, "MMM dd")
            }
        }
    }
}


