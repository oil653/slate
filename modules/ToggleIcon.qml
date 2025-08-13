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

    required property string offIcon;
    required property string onIcon;

    property string offColor: Colors.overlay1;
    property string onColor: Colors.overlay0;

    implicitHeight: 20;
    implicitWidth: 20;
    radius: 5;

    // isOn is not read only!
    property bool isOn: false;

    signal toggle()
    onToggle: isOn = !isOn;

    states: [
        State{
            name: "OFF";
            PropertyChanges{target: root; color: root.offColor;}
        },
        State{
            name: "ON";
            PropertyChanges{target: root; color: root.onColor;}
        }
    ]
    state: isOn ? "ON" : "OFF";

    Behavior on color{
        ColorAnimation{
            duration: 250;
            easing.type: Easing.OutQuad;
        }
    }
    IconImage{
        anchors.centerIn: parent;
        implicitSize: root.implicitHeight;
        source: (root.state === "ON") ? root.onIcon : root.offIcon;
    }
    MouseArea{
        anchors.fill: parent;
        onClicked: root.toggle();
        cursorShape: Qt.PointingHandCursor
    }
}