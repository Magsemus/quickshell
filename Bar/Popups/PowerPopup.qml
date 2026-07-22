import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import QtQuick.Shapes
import "../../ColorSchemes"

// If styling inside a PanelWindow or FloatingWindow

Item {
    id: powerContainer

    Colorscheme { id: theme }

    width: 400
    height: 80
    clip: true

    Behavior on height{
        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 16

        // 1. Log Out Button (Pinkish/Salmon tone)
        Rectangle {
            Layout.preferredWidth: 54
            Layout.preferredHeight: 54
            color: mouseArea1.containsPress ? theme.colClickBlue : (mouseArea1.containsMouse ? theme.colHoverBlue : theme.colLightBlue) // Soft light red/pink
            radius: 16

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            Image {
                anchors.centerIn: parent
                source: "../Utils/Files/power-symbol.svg" // Replace with your icon path or Nerd Font character
                sourceSize.width: 32
                sourceSize.height: 32
            }

            MouseArea {
                id: mouseArea1
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    Quickshell.execDetached(["systemctl", "poweroff"])
                    // Example: Quickshell.io.Process.run(["hyprctl", "dispatch", "exit", ""])
                }
            }
        }

        // 2. Power Button
        Rectangle {
            Layout.preferredWidth: 54
            Layout.preferredHeight: 54
            color: mouseArea2.containsPress ? theme.colClickBlue : (mouseArea2.containsMouse ? theme.colHoverBlue : theme.colLightBlue) // Soft light red/pink
            radius: 16

            Behavior on color {
                ColorAnimation { duration: 150 }
            } // Extremely faint tint or transparent if matching background

            Image {
                anchors.centerIn: parent
                source: "../Utils/Files/restart-symbol.svg"
                sourceSize.width: 32
                sourceSize.height: 32
            }

            MouseArea {
                id: mouseArea2
                anchors.fill: parent
                onClicked: Quickshell.execDetached(["systemctl", "reboot"])
                hoverEnabled: true
            }
        }

        // 3. Avatar Image (The character icon)
        Image {
            Layout.preferredWidth: 54
            Layout.preferredHeight: 54
            source: "images/avatar.png" // Path to your character png
            fillMode: Image.PreserveAspectFit

            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Avatar clicked")
            }
        }

        // 4. Update / Download Button
        Rectangle {
            Layout.preferredWidth: 54
            Layout.preferredHeight: 54
            color: mouseArea3.containsPress ? theme.colClickBlue : (mouseArea3.containsMouse ? theme.colHoverBlue : theme.colLightBlue) // Soft light red/pink
            radius: 16

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            Image {
                anchors.centerIn: parent
                source: "../Utils/Files/snooze-symbol.svg"
                sourceSize.width: 32
                sourceSize.height: 32
            }

            MouseArea {
                id: mouseArea3
                anchors.fill: parent
                onClicked: Quickshell.execDetached(["systemctl", "suspend"])
                hoverEnabled: true
            }
        }

        // 5. Reload / Refresh Button
        Rectangle {
            Layout.preferredWidth: 54
            Layout.preferredHeight: 54
            color: mouseArea4.containsPress ? theme.colClickBlue : (mouseArea4.containsMouse ? theme.colHoverBlue : theme.colLightBlue) // Soft light red/pink
            radius: 16

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            Image {
                anchors.centerIn: parent
                source: "../Utils/Files/lock-symboi.svg"
                sourceSize.width: 32
                sourceSize.height: 32
            }

            MouseArea {
                id: mouseArea4
                anchors.fill: parent
                onClicked: {
                    Quickshell.execDetached(["hyprlock"]);
                    // Quickshell provides automatic hot-reload, but you can assign actions here
                }
                hoverEnabled: true
            }
        }
    }
}

