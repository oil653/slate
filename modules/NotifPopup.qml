import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

// This will throw warns in the log if the same app sends the same notifications over and over
// The warnings are actually useless, and we want to show every notification even if its the same in everty detail
// Guess the logs will be ugly

Variants{
    model: Notif.popups;
    delegate: PanelWindow{
        id: root;
        property var modelData: modelData;
        property int index: Notif.popups.indexOf(modelData);
        property real marginOffset: index * (implicitHeight+10);

        anchors.top: true;
        anchors.left: true;
        margins.top: 10 + marginOffset;
        margins.left: 5;
        exclusiveZone: 0;
        implicitHeight: 80; implicitWidth: 250;
        color: "transparent";

        property real radius: 10;
        property var notif: modelData;
        Rectangle{
            id: bg;
            anchors.fill: parent;
            opacity: 0.9;
            
            // color: Colors.overlay1;
            color: "black";
            radius: root.radius;
            border{
                color: "white";
                width: 2;
            }
        }
        Item{
            id: fg;
            anchors.fill: parent;
            IconImage{
                id: hidePopup;
                anchors.top: parent.top; anchors.topMargin: 5;
                anchors.right: parent.right; anchors.rightMargin: 5;
                implicitSize: 20;
                source: "root:assets/icons/x.svg"
                MouseArea{
                    anchors.fill: parent;
                    onClicked: Notif.removePopup(root.notif);
                }
            }
            IconImage{
                id: dismissNotif;
                anchors.right: hidePopup.left; anchors.verticalCenter: hidePopup.verticalCenter;
                implicitSize: 20;
                source: "root:assets/icons/delete.svg"
                MouseArea{
                    anchors.fill: parent;
                    onClicked: Notif.dismissPopup(root.notif);
                }
            }
            Column{
                anchors.fill: parent;
                spacing: 5;
                anchors{
                    topMargin: 5;
                    leftMargin: 5;
                    rightMargin: 5;
                }
                Text{ // appName
                    id: appName
                    height: 8;
                    width: parent.width;
                    text: root.notif.appName;
                    color: Colors.text;
                    font.bold: true;
                    font.pointSize: 8;
                }
                Text{ // Summary
                    id: summary
                    height: 15;
                    width: parent.width;
                    text: root.notif.summary;
                    color: Colors.text;
                    font.bold: true;
                    font.pointSize: 14;
                }
                Text{ // Body
                    id: body;
                    height: parent.height - 8-15;
                    width: parent.width;
                    text: root.notif.body;
                    color: Colors.text;
                    font.bold: true;
                    font.pointSize: 10;
                    wrapMode: Text.WordWrap;
                }
            }
        }
    } 
}