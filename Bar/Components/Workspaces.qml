import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick // for Text
import QtQuick.Layouts
import "../../ColorSchemes"
import "../Utils"

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
        width: workspaceList.contentWidth + workspaceList.leftMargin + workspaceList.rightMargin      
        height: workspaceList.implicitHeight + 2
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

            spacing: 5
            implicitHeight: 18

            leftMargin: 15
            rightMargin: 15
            
            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter
            interactive: false 

            delegate: Item {
                id: delegateRoot

                // 1. Maintain a completely stable, non-collapsing width target boundary 
                // so icons and text never get squeezed together during transitions
                implicitWidth: layoutRow.childrenRect.width + 14
                height: parent.height - 3
                anchors.verticalCenter: parent.verticalCenter

                property var ws: workspaceObject 
                property bool isActive: Hyprland.focusedWorkspace?.id === wsId

                // 2. The Isolated Highlight Layer
                Rectangle {
                    id: highlightBackground
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    radius: 12
                    color: theme.colClickBlue

                    // Control the fading separately
                    opacity: delegateRoot.isActive ? 1.0 : 0.0
                    Behavior on opacity {
                        NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                    }

                    // Animate the growth right-ward across the static item space safely
                    width: delegateRoot.isActive ? parent.width : 0

                    Behavior on width {
                        NumberAnimation { duration: 500; easing.type: Easing.OutQuad }
                    }
                }

                // 3. The Content Layer (Stays completely static and un-cramped)
                Row {
                    id: layoutRow
                    anchors.verticalCenter: parent.verticalCenter 
                    anchors.left: parent.left
                    anchors.leftMargin: 7
                    spacing: 4

                    Text {
                        text: wsId + "."
                        color: delegateRoot.isActive ? theme.colCyan : theme.colBlue
                        font { pixelSize: 14; bold: true }
                        renderType: Text.NativeRendering
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    ListView {
                        model: ws.toplevels
                        height: parent.height
                        implicitWidth: contentWidth
                        anchors.verticalCenter: parent.verticalCenter
                        orientation: ListView.Horizontal
                        interactive: false
                        spacing: 6
                        leftMargin: 2

                        delegate: Item {
                            width: 16
                            height: 16
                            Image {
                                anchors.fill: parent
                                fillMode: Image.PreserveAspectFit
                                source: Icons.getAppIcon(modelData.wayland?.appId || "")
                                sourceSize.width: 16
                                sourceSize.height: 16
                                smooth: false
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

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
                    }
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
