//@ pragma UseQApplication
import Quickshell // for PanelWindow
import QtQuick // for Text
import QtQuick.Layouts
import "./Bar"
import "./Bar/Popups"
import "./Bar/Components/Base"
import "./ColorSchemes"

PanelWindow
{
    id: mainWindow

    anchors { 
        top: true
        left: true
        right: true
    }
    
    height: 500
    color: "transparent"

    exclusionMode: ExclusionMode.Normal
    exclusiveZone: 40 // Set this exactly to your top bar's height
    
    mask: Region {
        // Base region matches the bar
        Region
        {
            item: bar
        }
        Region
        {
            item: sidebarContainer
        }
        Region
        {
            item: serviceContainer
        }
    }
    
    Colorscheme { id: theme }

    Bar {   
        id: bar
        
        mainWindow: this.mainWindow
        middleWidget: sidebarContainer
        servicePopup: serviceContainer
        serviceMouseArea: serviceContainerMouseArea
    }
    
    BarWidget {
        id: sidebarContainer

        anchors.top: bar.bottom
        anchors.horizontalCenter: bar.horizontalCenter
    }

    Item {
        id: serviceContainerMouseArea

        anchors {
            left: serviceContainer.left
            right: serviceContainer.right
        }

        property int yOffset


        // Height animation directly on the container Item
        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
                onRunningChanged: {
                    if (!running) {
                        if (serviceContainerMouseArea.height === 0) {
                            hoverHandler.enabled = false;
                        }
                    }
                }
            }
        }

        HoverHandler {
            id: hoverHandler
        }

        property HoverHandler hoveringHandler: hoverHandler
    }

    BarWidget {
        id: serviceContainer

        anchors.top: bar.bottom

        HoverHandler {
            id: panelHover
        }
    }
    
    property bool isMenuActive: hoverHandler.hovered || panelHover.hovered

    onIsMenuActiveChanged: {
        if (isMenuActive) {
            // Expand the menu
            serviceContainer.height = serviceContainer.rectHeight;
            serviceContainerMouseArea.height = serviceContainer.rectHeight + serviceContainerMouseArea.yOffset;
        } else {
            // Shrink the menu
            serviceContainer.height = 0;
            serviceContainerMouseArea.height = 0;
        }
    }

}
