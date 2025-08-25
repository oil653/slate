import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services

Item{
    implicitWidth: height;
    IconImage{
        implicitSize: parent.height;
        source: Power.batteryIcon;
    }
}