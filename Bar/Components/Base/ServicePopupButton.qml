import Quickshell
import QtQuick


Item {
    width: _scriptButton.width
    height: _scriptButton.height

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
    
    property var serviceMouseArea
    property var servicePopup
    property var content

    property string scriptPath: ""
    property var procAction: function(line) {}
    property string textIcon: ""
    property string buttonAnimationType: "pop"
    property ServiceScriptButton scriptButton: _scriptButton

    function triggerIconUpdate(nextIcon) {
        _scriptButton.triggerIconUpdate(nextIcon);
    }

    ServiceScriptButton {
        id: _scriptButton
        clickedAction: function() { 
            servicePopup.serviceButtonHover = true
            let Y = getHeightOffset(this);
            serviceMouseArea.yOffset = servicePopup.y - Y
            if (servicePopup.contentLoader.source != "../../Popups/" + content + ".qml") 
            { 
                servicePopup.contentLoader.active = true
                servicePopup.contentLoader.source = "../../Popups/" + content + ".qml"
                servicePopup.module = this

                serviceMouseArea.y = Y;
                serviceMouseArea.height = servicePopup.rectHeight + serviceMouseArea.yOffset;
                serviceMouseArea.hoveringHandler.enabled = true
            }
            else
            {
                servicePopup.contentLoader.active = true
                servicePopup.height = servicePopup.rectHeight;
                serviceMouseArea.height = servicePopup.rectHeight + serviceMouseArea.yOffset;
                serviceMouseArea.hoveringHandler.enabled = true
            }
        }
        mouseHoverExit: function () {
            servicePopup.serviceButtonHover = false
            if (servicePopup.height > 0 && !servicePopup.isBothHovered)
            {
                servicePopup.height = 0;
                serviceMouseArea.height = 0;
            }
        }

        scriptPath: parent.scriptPath
        procAction: parent.procAction
        textIcon: parent.textIcon
        buttonAnimationType: parent.buttonAnimationType
    }
}
