import Quickshell 
import QtQuick
import QtQuick.Shapes
import "../../../ColorSchemes"



Item {
    id: gauge
    width: 75
    height: 75
    
    Colorscheme { id: theme }

    // Value from 0.0 to 1.0 (e.g. 0.40 for ~15 Mbps on a log gauge)
    property real progress: 0.8

    // Gauge geometry parameters
    readonly property real minAngle: 135   // Bottom-left start (0 Mbps)
    readonly property real maxSweep: 270   // Total angular span of the gauge
    readonly property real arcRadius: width/2.5 // Center-line radius of the arc
    readonly property real arcThickness: 5// Width of the blue bar
    readonly property var ticks: [0, 1, 5, 10, 25, 50, 75, 100];

    property Text currentMeasurement: _currentMeasurement

    Shape {
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 4 // Ensures smooth antialiased edges
        preferredRendererType: Shape.CurveRenderer

        // 1. Background Dark Track
        ShapePath {
            strokeColor: "#222530"        // Dark gray background track
            strokeWidth: gauge.arcThickness
            fillColor: "transparent"
            capStyle: ShapePath.FlatCap   // Sharp, flat ends

            PathAngleArc {
                centerX: gauge.width / 2
                centerY: gauge.height / 2
                radiusX: gauge.arcRadius
                radiusY: gauge.arcRadius
                startAngle: gauge.minAngle
                sweepAngle: gauge.maxSweep
            }
        }

        // 2. Active Blue/Cyan Speed Arc
        ShapePath {
            strokeColor: "#00d2ff"        // Vibrant speed gauge blue/cyan
            strokeWidth: gauge.arcThickness
            fillColor: "transparent"
            capStyle: ShapePath.FlatCap   // Gives the flat cut at speed 0 and current speed

            PathAngleArc {
                centerX: gauge.width / 2
                centerY: gauge.height / 2
                radiusX: gauge.arcRadius
                radiusY: gauge.arcRadius
                startAngle: gauge.minAngle
                
                // Active arc length scales with current speed value
                sweepAngle: gauge.maxSweep * gauge.progress

                // Smoothly animate the gauge needle/arc movement
                Behavior on sweepAngle {
                    NumberAnimation { 
                        duration: 300 
                        easing.type: Easing.OutQuad 
                    }
                }
            }
        }
    }

    Shape {
        id: dial

        implicitWidth: parent.width / 4
        implicitHeight: parent.height * 0.1

        x: parent.width / 2 - width
        y: parent.height / 2  - height / 2
        
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 0

            fillGradient: LinearGradient {
                x1: 0; y1: dial.height / 2
                x2: dial.width; y2: dial.height / 2

                GradientStop { position: 0.0; color: theme.colFg}
                GradientStop { position: 1.0; color: "transparent"}
            }

            startX: dial.width
            startY: dial.height

            PathLine {
                x: dial.width
                y: 0
            }

            PathLine {
                x: 0
                y: dial.height * 0.2
            }

            PathLine {
                x: 0
                y: dial.height - dial.height * 0.2
            }

            PathLine {
                x: dial.width
                y: dial.height
            }
        }

        transform: Rotation {
            id: dialRotation
            angle: gauge.maxSweep * gauge.progress -45
            origin.x: dial.width 
            origin.y: dial.height / 2

            Behavior on angle {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutQuad // Smooth deceleration
                }
            }
        }
    }

    Text {
        id: _currentMeasurement

        text: "12.6"
        color: theme.colFg
        font { family: theme.fontFamily; pixelSize: parent.width * (8/75); bold: true }
        renderType: Text.NativeRendering
        
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height - _unit.height - height
    }

    Text {
        id: _unit
        
        text: "MB/s"
        color: theme.colFg
        font { family: theme.fontFamily; pixelSize: parent.width * (8/75); bold: true }
        renderType: Text.NativeRendering
        
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height - height
        
    }

    Repeater {
        model: gauge.ticks.length

        Text {
            text: gauge.ticks[index]
            color: theme.colFg
            font { family: theme.fontFamily; pixelSize: parent.width * (8/75); bold: true }
            renderType: Text.NativeRendering

            property var radOffset: Math.PI / 180
            property var xOffset:(gauge.arcRadius + gauge.arcThickness) * Math.cos(radOffset * (225 - (270 * (index / 7))))
            property var yOffset: (gauge.arcRadius + gauge.arcThickness) * Math.sin(radOffset * (225 - (270 * (index / 7))))

            x: (xOffset < 0) ? (gauge.width / 2) + xOffset + implicitWidth * Math.cos(radOffset * (225 - (270 * (index / 7)))) : (gauge.width / 2) + xOffset
            y: (yOffset > 0) ? (gauge.height / 2) - yOffset - implicitHeight * Math.sin(radOffset * (225 - (270 * (index / 7)))) : (gauge.height / 2) - yOffset
        }
    }

    function speedToProgress(speedMB) {
        // 8 tick values corresponding to indices 0 through 7
        // Clamp lower bound
        if (speedMB <= 0) return 0.0;

        // Clamp upper bound (100+ MB/s -> 1.0)
        if (speedMB >= 100) return 1.0;

        // Find which segment speedMB falls into
        for (var i = 0; i < ticks.length - 1; i++) {
            var lower = ticks[i];
            var upper = ticks[i + 1];

            if (speedMB >= lower && speedMB <= upper) {
                // How far between lower and upper ticks are we? (0.0 to 1.0 within segment)
                var segmentProgress = (speedMB - lower) / (upper - lower);

                // Map segment index to overall 0..1 scale (each step is 1/7)
                var baseFraction = i / 7.0;
                var stepSize = 1.0 / (ticks.length - 1);

                return baseFraction + (segmentProgress * stepSize);
            }
        }

        return 1.0;
    }
}
