import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

Rectangle{
    id: root;

    required property string icon;

    // animationColor is the color the button will change for animationTime after the button was pressed
    property string defaultColor: Colors.overlay1;
    property string animationColor: Colors.overlay0;

    property real animationTime : 150; //ms

    signal pushed();


    implicitHeight: 20;
    implicitWidth: 20;
    radius: 5;

    // is pushed is internal property and should not be edited from the outside
    onPushed: __isPushed = true;
    property bool __isPushed: false;

    Timer{
        running: __isPushed; repeat: false; interval: animationTime;
        onTriggered: {
            __isPushed = false;
        }
    }
    states: [
        State{
            name: "OFF";
            PropertyChanges{target: root; color: root.defaultColor;}
        },
        State{
            name: "ON";
            PropertyChanges{target: root; color: root.animationColor;}
        }
    ]
    state: __isPushed ? "ON" : "OFF";

    Behavior on color{
        ColorAnimation{
            duration: animationTime/2;
            easing.type: Easing.OutQuad;
        }
    }
    IconImage{
        anchors.centerIn: parent;
        implicitSize: root.implicitHeight;
        source: root.icon;
    }
    MouseArea{
        anchors.fill: parent;
        onClicked: root.pushed();
        cursorShape: Qt.PointingHandCursor
    }
}