import Quickshell 
import QtQuick 
import QtQuick.Shapes

Rectangle 
{
    height: _contentLoader.item ? _contentLoader.item.height : 0
    //color: theme.colDarkBlue // Off-white/cream background matching the image
    color: "transparent"
    clip: true

    bottomLeftRadius: 12
    bottomRightRadius: 12

    anchors.top: bar.bottom
    anchors.horizontalCenter: bar.horizontalCenter

    property int rectHeight

    y: this.y + 1

    Behavior on height{
        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }

    Behavior on width{
        enabled: sidebarContainer.height > 0

        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }

    Shape {
        id: shape
        width: parent.width
        height: parent.height

        property int arcQuadRad: 10
        property int cornerRad: 15

        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 0
            fillColor: theme.colDarkBlue

            // Start at x = -1, which maps to top-left (0, 0)
            startX: 0
            startY: 0

            // PathQuad draws the exact curve to the end point (width, height)
            PathQuad {
                x: shape.arcQuadRad    // End X (x = 0)
                y: shape.arcQuadRad * shape.height/sidebarContainer.rectHeight       // End Y (y = -1)
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
                y: shape.arcQuadRad * shape.height/sidebarContainer.rectHeight
            }
            
            PathQuad {
                x: shape.width     // End X (x = 0)
                y: 0       // End Y (y = -1)
                controlX: shape.width - shape.arcQuadRad // Tangent intersection X
                controlY: 0          // Tangent intersection Y
            }
            
        }
    }

    Loader {
        id: _contentLoader

        onItemChanged: {
            if (item != null)
            {
                sidebarContainer.width = item.width + 20
                sidebarContainer.rectHeight = item.height
            }
        }

        anchors.centerIn: parent
    }

    property Loader contentLoader: _contentLoader
}
