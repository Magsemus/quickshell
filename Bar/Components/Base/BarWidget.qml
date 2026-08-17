import Quickshell 
import QtQuick 
import QtQuick.Shapes
import QtQuick.Effects

Rectangle 
{
    id: popupRect

    height: rectHeight ? rectHeight : 0
    //color: theme.colDarkBlue // Off-white/cream background matching the image
    color: "transparent"
    clip: true

    bottomLeftRadius: 12
    bottomRightRadius: 12

    property int rectHeight
    property int rectWidth
    property var module

    x: {
        if (!module || !parent) return 0;

        let sum = 0;
        let currentParent = module;

        while (currentParent)
        {
            sum = sum + currentParent.x;
            currentParent = currentParent.parent;
        }

        let center = sum + module.width/2;
        
        return center - rectWidth / 2;
    }

    Behavior on height{
        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }

    Behavior on width{
        enabled: height > 0

        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }

    Behavior on x{
        enabled: height > 0

        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }

    Shape {
        id: shape
        width: parent.width
        height: parent.height

        anchors.centerIn: parent

        property int arcQuadRad: 10
        property int cornerRad: 15

        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 0

            fillGradient: LinearGradient {
                x1: shape.width; y1: 0
                x2: shape.width; y2: shape.height
                GradientStop { position: 1.0; color: "#110d1a" } // Orange
                GradientStop { position: 0.0; color: theme.colDarkBlue } // Yellow
            }

            // Start at x = -1, which maps to top-left (0, 0)
            startX: 0
            startY: 0

            // PathQuad draws the exact curve to the end point (width, height)
            PathQuad {
                x: shape.arcQuadRad    // End X (x = 0)
                y: shape.arcQuadRad * shape.height/rectHeight       // End Y (y = -1)
                controlX: shape.arcQuadRad // Tangent intersection X
                controlY: 0           // Tangent intersection Y
            }
            PathLine {
                x: shape.arcQuadRad   // Keep the x-position at the max width
                y: shape.height - shape.arcQuadRad             // Draw up to the y-axis height (0)
            }

            // 3b. (Optional) Explicitly close the path horizontally along the x-axis.
            // ShapePath automatically closes the loop back to (startX, startY), but
            // adding this line explicitly provides more control over the bottom border if needed.
            PathArc {
                x: shape.arcQuadRad + shape.cornerRad; y: shape.height
                radiusX: shape.cornerRad; radiusY: shape.cornerRad
                direction: PathArc.Counterclockwise
            }

            PathLine {
                x: shape.width - (shape.arcQuadRad + shape.cornerRad)
                y: shape.height
            }

            PathArc {
                x: shape.width - shape.arcQuadRad; y: shape.height - shape.cornerRad
                radiusX: shape.cornerRad; radiusY: shape.cornerRad
                direction: PathArc.Counterclockwise
            }

            PathLine {
                x: shape.width - shape.arcQuadRad
                y: shape.arcQuadRad * shape.height/rectHeight
            }
            
            PathQuad {
                x: shape.width     // End X (x = 0)
                y: 0       // End Y (y = -1)
                controlX: shape.width - shape.arcQuadRad // Tangent intersection X
                controlY: 0          // Tangent intersection Y
            }
            
        }
    }

    MultiEffect {
        anchors.fill: shape
        source: shape
        
        shadowEnabled: true
        shadowColor: theme.colDarkBlue // Light pink glow matching wallpaper
        shadowBlur: 0.1 // Blur intensity
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 1
    }

    Loader {
        id: _contentLoader

        property Rectangle backgroundRect: popupRect

        onHeightChanged: {
            if (popupRect.height != 0) {
                popupRect.width = item.width + 20
                popupRect.rectHeight = item.height
                popupRect.rectWidth = item.width + 20 
            }
        }

        onWidthChanged: {
            popupRect.width = item.width + 20
            popupRect.rectWidth = item.width + 20 
        }

        anchors.centerIn: parent

        onItemChanged: {
            if (item != null) popupRect.rectHeight = item.height
            else popupRect.rectHeight = 0
        }
    }
    
    onHeightChanged: {
        if (height == 0) {
            _contentLoader.active = false
        }
    }

    property Loader contentLoader: _contentLoader
}
