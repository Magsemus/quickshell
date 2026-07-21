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

    BarWidget {
        id: serviceContainer

        anchors.top: bar.bottom
    }

    MouseArea {
        id: serviceContainerMouseArea
        anchors {
            left: serviceContainer.left
            right: serviceContainer.right
        }
        hoverEnabled: true

        Behavior on height{
            NumberAnimation { 
                duration: 200 
                easing.type: Easing.OutQuad 
                onRunningChanged: {
                    if (!running) {
                        if (serviceContainerMouseArea.height == 0)
                        {
                            hoverEnabled = false;
                        }
                    }
                }
            }
        }

        property int yOffset 
        
        onEntered: {
            serviceContainer.height = serviceContainer.rectHeight;
            height = serviceContainer.rectHeight + yOffset;
        }

        onExited: {
            serviceContainer.height = 0;
            height = 0;
        }
    }

}
