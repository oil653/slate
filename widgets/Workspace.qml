import QtQuick
import QtQuick.Layouts
import Quickshell.I3
import Quickshell.Widgets
import Quickshell
import qs.components

// Widget for Sway and I3 workspaces


Rectangle{
    id: root;
    color: "Transparent";
    required property string currentMonitor; // The caller passes the current monitor for sorting
    implicitWidth: bg.implicitWidth;


    states: [
        State{
            name: "NORMAL";
            PropertyChanges{ // Here both the bg and the workspace instance's properties will be modified because of qml limitations
                target: bg;
                iColor: Colors.surface0;
                secondaryColor: Colors.overlay0;
                activeColor: Colors.overlay1;
                textColor: Colors.text;
                outlinedTextColor: Colors.text1;
                activeTextColor: Colors.overlay0;
                urgentColor: Colors.red;
                urgentTextColor: Colors.yellow;
            }
        },
        State{
            name: "MIN";
            PropertyChanges{
                target: bg;
                iColor: "transparent";
                secondaryColor: "transparent";
                activeColor: "transparent";
                textColor: Colors.text;
                outlinedTextColor: Colors.text2;
                activeTextColor: Colors.overlay1;
                urgentColor: "transparent";
                urgentTextColor: Colors.red;
            }
        }
    ]
    state: (Config.minimalWorkspace) ? "MIN" : "NORMAL";

    WrapperRectangle{ // idk why i named this bg, but there must be some logic behind it
        id: bg;
        anchors.centerIn: parent;
        width: row.implicitWidth;
        color: "transparent";

        // properties the workspace instance will access
        // the state above cant change the instances but the instance can acess these properties
        property string secondaryColor;
        property string iColor; // instaceColor
        property real radius: 13;
        property string textColor;
        property string outlinedTextColor;
        property string activeColor;
        property string activeTextColor;
        property string urgentColor;
        property string urgentTextColor;

        Row{ // Workspaces
            id: row;
            anchors.centerIn: parent;
            Repeater{
                model: ScriptModel {  
                        values: {
                            if (!currentMonitor) return I3.workspaces.values;
                            return I3.workspaces.values.filter(workspace =>
                                workspace.monitor && workspace.monitor.name === currentMonitor
                            );
                        }
                    }
                Rectangle{ // workspace
                    id: workspace;
                    property var model: modelData;
                    property int totalElementCount: { // It does the same calculation as the repeater to get the total amount of instance
                        if (!currentMonitor) return I3.workspaces.values.length;
                        return I3.workspaces.values.filter(workspace =>
                            workspace.monitor && workspace.monitor.name === currentMonitor
                        ).length;
                    }
                    property bool isFirst: (index === 0); // Is the first element in the column
                    property bool isLast: (index === totalElementCount - 1); // Is the last element in the column

                    width: root.height;
                    height: root.height;
                    
                    // Applies radius depending on the position of the item
                    topLeftRadius: (isFirst) ? bg.radius : 0;
                    bottomLeftRadius: (isFirst) ? bg.radius : 0;
                    topRightRadius: (isLast) ? bg.radius : 0;
                    bottomRightRadius: (isLast) ? bg.radius : 0;

                    color: (model.focused) ? bg.secondaryColor : (model.active) ? bg.activeColor : (model.urgent) ? bg.urgentColor : bg.iColor ;
                    border.width: 0;

                    Behavior on color { 
                        ColorAnimation { 
                            duration: 100;
                            easing.type: Easing.OutQuad;
                        }
                    }
                    Text{
                        id: workspaceText;
                        anchors.centerIn: parent;
                        text: workspace.model.name;
                        font.pixelSize: parent.height - (parent.height/4);
                        color: (parent.model.focused) ? bg.outlinedTextColor : (parent.model.active) ? bg.activeTextColor : (parent.model.urgent) ? bg.urgentTextColor : bg.textColor;
                        Behavior on color {  
                            ColorAnimation {  
                                duration: 200;
                                easing.type: Easing.OutQuad;
                            }
                        }
                    }
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: {
                            parent.model.activate();
                        }
                    }
                    
                    // Initial state for new items  
                    scale: 0;
                    opacity: 0;
                    
                    // Transition when item is added
                    Component.onCompleted: {
                        scaleAnim.start();
                        opacityAnim.start();  
                    }  
                    
                    NumberAnimation {  
                        id: scaleAnim;  
                        target: workspace;
                        property: "scale"; 
                        from: 0;
                        to: 1;
                        duration: 100;
                        easing.type: Easing.InBounce;
                    }  
                    
                    NumberAnimation {  
                        id: opacityAnim;
                        target: workspace;
                        property: "opacity";
                        from: 0;
                        to: 1;
                        duration: 150;
                        easing.type: Easing.OutQuad;
                    }  
                }
            }
        }
    }
}