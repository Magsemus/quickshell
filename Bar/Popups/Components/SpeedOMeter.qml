import Quickshell 
import QtQuick
import "../../../ColorSchemes"
import QtQuick
import QtQuick.Shapes

Rectangle {
    id: background

    width: 75
    height: 75
    color: "transparent" // Match image background

    Colorscheme { id: theme }

    property int thickness: 3
    property int maxValue: 10
    property int value: 2

    Shape {
        id: backgroundShape

        width: parent.width
        height: parent.height
    
        // Smooth edges
        layer.enabled: true
        layer.samples: 4

        preferredRendererType: Shape.CurveRenderer

        // --- PART 1: The full background arc (dark grey) ---
        ShapePath {
            strokeWidth: 0
            fillColor: theme.colFg // We don't want to fill the center circle
            capStyle: ShapePath.FlatCap // Flat edges at the 0 and 1000 points

            // Path starting point (requires some basic math to center it)
            startX: backgroundShape.width * (1/4)
            startY: backgroundShape.height

            PathArc {
                // Defines the endpoint of the full 0-1000 range
                x: backgroundShape.width * (3/4)
                y: backgroundShape.height

                // Control how circular the arc is (relative to start/end)
                radiusX: backgroundShape.width / 2
                radiusY: backgroundShape.width / 2
                useLargeArc: true // Wraps the long way around
                direction: PathArc.Clockwise
            }
            PathLine {
                x: backgroundShape.width * (3/4) - background.thickness
                y: backgroundShape.height - background.thickness
            }

            PathArc {
                // Defines the endpoint of the full 0-1000 range
                x: backgroundShape.width * (1/4) + background.thickness
                y: backgroundShape.height - background.thickness

                // Control how circular the arc is (relative to start/end)
                radiusX: backgroundShape.width / 2 - Math.sqrt(2*(background.thickness * background.thickness))
                radiusY: backgroundShape.width / 2 - Math.sqrt(2*(background.thickness * background.thickness))
                useLargeArc: true // Wraps the long way around
                direction: PathArc.Counterclockwise
            }

            PathLine {
                x: backgroundShape.width * (1/4)
                y: backgroundShape.height
            }
        }
    }
}
