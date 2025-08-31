import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services

ClippingRectangle{
    implicitWidth: height + (Power.onBattery ? 50 : 0);
    color: "transparent"
    IconImage{
        id: icon;
        anchors.top: parent.top;
        anchors.left: parent.left;
        implicitSize: parent.height;
        source: Power.batteryIcon;
        // Rectangle{anchors.fill: parent}
    }
    Text{
        visible: Power.onBattery && (Power.source.timeToFull + Power.source.timeToEmpty !==0);
        anchors.left: icon.right;
        anchors.leftMargin: 2;

        text: Power.formatTime(Power.source.timeToFull + Power.source.timeToEmpty);
        color: (Power.sourceIsCharging) ? Colors.green : Colors.red;
        font.pixelSize: 20;
    }
}