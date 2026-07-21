import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick // for Text
import QtQuick.Layouts
import Quickshell.Widgets
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
    
    width: parent.width - 10
    height: 35
    radius: 12

    color: theme.colDarkBlue

    property PanelWindow mainWindow 
    property BarWidget middleWidget 
    property BarWidget servicePopup
    property Item serviceMouseArea

    property RowLayout rightSectionLayout: rightSection

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

        color: theme.colDarkerBlue

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

        property Rectangle serviceScriptButtonRectangle: serviceScriptButtonRect

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

            width: servicesLayoutRow.width + 10
            height: servicesLayoutRow.height + 0
            color: theme.colLightBlue

            property Row serviceLayoutRowRect: servicesLayoutRow

            Row
            {
                id: servicesLayoutRow
                anchors.centerIn: parent

                property ServiceScriptButton powerProfileButton: powerProfile

                function getHeightOffset(module) : int
                {   
                    if (!module || !parent) return 0;

                    let sum = 0;
                    let currentParent = module;

                    while (currentParent)
                    {
                        sum = sum + currentParent.y;
                        currentParent = currentParent.parent;
                    }

                    return (sum + module.height);
                }

                ServiceScriptButton {
                    id: wifi
                    clickedAction: function() { 
                        let Y = servicesLayoutRow.getHeightOffset(this) + 1;
                        serviceMouseArea.yOffset = servicePopup.y - Y

                        if (servicePopup.contentLoader.source != "../../Popups/WifiPopup.qml") 
                        { 
                            servicePopup.contentLoader.source = "../../Popups/WifiPopup.qml";
                            servicePopup.module = this;
                            
                            serviceMouseArea.y = Y;
                            serviceMouseArea.height = servicePopup.rectHeight + serviceMouseArea.yOffset;       
                            serviceMouseArea.hoveringHandler.enabled = true

                        }
                        else
                        {
                            servicePopup.height = servicePopup.rectHeight;
                            serviceMouseArea.height = servicePopup.rectHeight + (servicePopup.y - Y);
                            serviceMouseArea.hoveringHandler.enabled = true
                        }
                    }
                    mouseHoverExit: function () {
                        if (servicePopup.height > 0)
                        {
                            servicePopup.height = 0;
                            serviceMouseArea.height = 0;
                        }
                    }
                    scriptPath: "/home/magse/.config/quickshell/Bar/Scripts/wifi_steam.sh"
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
                }

                ServiceButton { 
                    id: bluetooth
                    activeIcon: "󰂯"
                    onClickedAction: function () {
                        console.log("GIGGITY BLUETOOTH!")
                    }
                    clickAble: false
                }

                ServiceScriptButton {
                    id: powerProfile
                    clickedAction: function() { 
                        let Y = servicesLayoutRow.getHeightOffset(this) + 1;
                        serviceMouseArea.yOffset = servicePopup.y - Y

                        if (servicePopup.contentLoader.source != "../../Popups/PowerProfilesPopup.qml") 
                        { 
                            servicePopup.contentLoader.source = "../../Popups/PowerProfilesPopup.qml"
                            servicePopup.module = this

                            serviceMouseArea.y = Y;
                            serviceMouseArea.height = servicePopup.rectHeight + serviceMouseArea.yOffset;
                            serviceMouseArea.hoveringHandler.enabled = true
                        }
                        else
                        {
                            servicePopup.height = servicePopup.rectHeight;
                            serviceMouseArea.height = servicePopup.rectHeight + (servicePopup.y - Y);
                            serviceMouseArea.hoveringHandler.enabled = true
                        }
                    }
                    mouseHoverExit: function () {
                        if (servicePopup.height > 0)
                        {
                            servicePopup.height = 0;
                            serviceMouseArea.height = 0;
                        }
                    }
                    scriptPath: "/home/magse/.config/quickshell/Bar/Scripts/power_stream.sh"
                    procAction: function(line) {
                        let cleanLine = line.trim();
                        triggerIconUpdate(cleanLine);
                    }
                    textIcon: ""
                }
            }
        }

        Rectangle
        {
            Layout.rightMargin: 24
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
                    procCommand: "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits"
                }
            }
        }

        ServiceButton { 
            id: power 
            activeIcon: "\u200A\u2001"
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
            width: 28
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            onTriggered: {
                cpu.update()
                mem.update()
                gpu.update()

                var now = new Date()
                clock.text = Qt.formatDateTime(now, "HH:mm")
                dateTime.text = Qt.formatDateTime(now, "MMM dd")
            }
        }
    }
}


