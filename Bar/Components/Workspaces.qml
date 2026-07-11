import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick // for Text
import QtQuick.Layouts
import "../../ColorSchemes"

Item {   
    id: root

    Colorscheme { id: theme }

    // 1. Create a persistent ListModel that doesn't reset its entire identity
    ListModel {
        id: dynamicWorkspaceModel
        
        // This helper function updates our model smoothly by only adding/removing what changed
        function syncModel() {
            // 1. Clone the array using [...] so JavaScript is allowed to mutate/sort it
            let rawSpaces = [...Hyprland.workspaces.values]
            .filter(ws => ws.id > 0)
            .sort((a, b) => a.id - b.id); // This will now successfully sort: 1, 2, 3...

            // 2. Remove items no longer present
            for (let i = dynamicWorkspaceModel.count - 1; i >= 0; i--) {
                let currentId = dynamicWorkspaceModel.get(i).wsId;
                if (!rawSpaces.some(ws => ws.id === currentId)) {
                    dynamicWorkspaceModel.remove(i);
                }
            }

            // 3. Add new items matching their target positions smoothly
            rawSpaces.forEach((ws) => {
                let found = false;
                for (let i = 0; i < dynamicWorkspaceModel.count; i++) {
                    if (dynamicWorkspaceModel.get(i).wsId === ws.id) {
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    // Find the correct index to insert it so it stays sorted during animations
                    let insertIndex = 0;
                    while (insertIndex < dynamicWorkspaceModel.count && dynamicWorkspaceModel.get(insertIndex).wsId < ws.id) {
                        insertIndex++;
                    }
                    dynamicWorkspaceModel.insert(insertIndex, { "wsId": ws.id, "workspaceObject": ws });
                }
            });
        }
    }

    // 2. Automatically sync the list model whenever Hyprland's workspaces change
    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() { dynamicWorkspaceModel.syncModel(); }
        // Run once on load to populate the initial list
        Component.onCompleted: dynamicWorkspaceModel.syncModel();
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: workspaceList.implicitWidth + 30      
        height: workspaceList.height + 2
        radius: 12
        color: theme.colLightBlue

        Behavior on width {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuad }
        }

        ListView {
            id: workspaceList
                
            // 3. Point your ListView to the persistent ListModel
            model: dynamicWorkspaceModel

            orientation: ListView.Horizontal
            spacing: 0 
            height: 18

            leftMargin: 15
            rightMargin: 15
            
            implicitWidth: contentWidth
            anchors.verticalCenter: parent.verticalCenter
            interactive: false 

            delegate: Item {
                id: delegateContainer
                width: 20  
                height: 18

                // 4. Reference variables via the dynamic list model fields now
                property var ws: workspaceObject 
                property bool isActive: Hyprland.focusedWorkspace?.id === wsId

                Text {
                    anchors.fill: parent
                    text: wsId
                    color: isActive ? theme.colCyan : theme.colBlue
                    font { pixelSize: 14; bold: true }
                    renderType: Text.NativeRendering
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (wsId) + " })")
                }
            }

            // Transitions will now properly detect item variations:
            add: Transition {
                NumberAnimation { property: "y"; from: 5; to: 0; duration: 300; easing.type: Easing.OutQuad }
                NumberAnimation { property: "scale"; from: 0.0; to: 1.0; duration: 300; easing.type: Easing.OutQuad }
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 250 }
            }

            remove: Transition {
                ParallelAnimation {
                    NumberAnimation { property: "width"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
                    NumberAnimation { property: "opacity"; to: 0.0; duration: 200 }
                }
            }

            displaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
