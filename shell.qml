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
    }
    
    Colorscheme { id: theme }

    Bar {   
        id: bar
        
        mainWindow: this.mainWindow
        middleWidget: sidebarContainer
    }
    
    BarWidget {
        id: sidebarContainer
    }
}
