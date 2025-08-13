import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

PanelWindow{
    id: root;
    anchors.top: true;
    anchors.left: true;
    margins.top: 10;
    margins.left: 5;
    exclusiveZone: 0;
    implicitHeight: 80; implicitWidth: 250;
    color: "transparent";

    property real radius: 10;
    required property var notif; // The passed notification of type notfication 
    Rectangle{
        id: bg;
        anchors.fill: parent;
        opacity: 0.6;
        
        color: Colors.overlay1;
        radius: root.radius;
        border{
            color: "white";
            width: 2;
        }
    }
    Item{
        id: fg;
        anchors.fill: parent;
        Column{
            anchors.fill: parent;
            anchors{
                topMargin: 5;
                leftMargin: 5;
                rightMargin: 5;
            }
            Row{
                height: 10; width: parent.width;
                Text{

                }
            }
        }
    }
}