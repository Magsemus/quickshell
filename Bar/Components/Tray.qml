import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../Utils"

ListView {
    orientation: ListView.Horizontal
    spacing: 8
    
    // Explicit sizing for the tray container bounds
    height: 18
    implicitWidth: contentWidth

    reuseItems: false
    cacheBuffer: 200

    Behavior on implicitWidth {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    // Repeater loops through all the active tray items provided by the SystemTray singleton

    model: SystemTray.items

    delegate: MouseArea {
        id: trayItemRoot

        // SystemTray.items gives us access to a "modelData" object for each item
        width: 18
        height: 18
        hoverEnabled: true

        // Render the tray icon
        IconImage {
            anchors.fill: parent
            opacity: trayItemRoot.containsMouse ? 1.0 : 0.85
            source: Icons.getTrayIcon(modelData.id, modelData.icon)
        }

        // Handle user interactions (Clicks)
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                // Triggers the primary action (e.g., opening the app window)
                modelData.activate();
            } else if (mouse.button === Qt.RightButton) {
                // Opens the application's context menu at the cursor's location
                modelData.display(mainWindow, mouse.x, mouse.y);
            }
        }
    }

    add: Transition {
        // Start slightly lower (y: 5) and move up to its layout position (y: 0)
        NumberAnimation { property: "y"; from: 5; to: 0; duration: 300; easing.type: Easing.OutQuad }
        // Scale up from 70% to 100%
        NumberAnimation { property: "scale"; from: 0.0; to: 1.0; duration: 300; easing.type: Easing.OutQuad }
        // Fade in
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 250 }
    }

    // When a daemon closes: Pop out shrinking down to 0% size
    remove: Transition {
        ParallelAnimation {
            // Shrink the width to 0 so neighboring icons slide over smoothly
            NumberAnimation { property: "width"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
            NumberAnimation { property: "opacity"; to: 0.0; duration: 200 }
        }
    }

    // The Magic: Slide the remaining icons smoothly to their new positions
    displaced: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: 250
            easing.type: Easing.InOutQuad
        }
    }
}
