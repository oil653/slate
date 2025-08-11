import QtQuick
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services

Item {
    id: circleBar
    property real length: 0;     // total duration in seconds
    property real timestamp: 0;   // current playback time in seconds
    property color baseColor: Colors.surface0; // base circle color
    property color progressColor: Colors.overlay0; // progress arc color
    property int thickness: 4
    width: parent.height
    height: parent.height

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var radius = Math.min(width, height) / 2 - circleBar.thickness / 2;
            var centerX = width / 2;
            var centerY = height / 2;

            // Draw base circle
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
            ctx.strokeStyle = circleBar.baseColor;
            ctx.lineWidth = circleBar.thickness;
            ctx.stroke();

            // Draw progress if possible
            if (circleBar.length > 0 && circleBar.timestamp > 0) {
                var angle = Math.max(0, Math.min(1, circleBar.timestamp / circleBar.length)) * 2 * Math.PI;
                ctx.beginPath();
                ctx.arc(centerX, centerY, radius, -Math.PI/2, -Math.PI/2 + angle, false);
                ctx.strokeStyle = circleBar.progressColor;
                ctx.lineWidth = circleBar.thickness;
                ctx.lineCap = "round";
                ctx.stroke();
            }
        }
    }

    // Update whenever timestamp or length changes
    onLengthChanged: canvas.requestPaint()
    onTimestampChanged: canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()
}