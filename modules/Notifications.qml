import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

PopupPos{
    id: root;

    implicitHeight: 200; 
    implicitWidth: 250;
    Component.onCompleted: Notif.hasUnseen = false;
    Item{ // Control panel
        id: controlPanel;
        anchors.top: parent.top;
        anchors.left: parent.left; anchors.right: parent.right;
        anchors.topMargin: 5; anchors.leftMargin: 5;
        implicitHeight: 30;
        Row{
            anchors.fill: parent;
            spacing: 5;
            ToggleIcon{ // Silent on off
                implicitHeight: controlPanel.height; implicitWidth: (parent.width-10) / 2; // -10 because of the two margin on the side
                radius: 5;
                onIcon: "root:assets/icons/bell_silent_on";
                offIcon: "root:assets/icons/bell_silent_off";
                isOn: Notif.isSilent;
                onToggle: Notif.isSilent = isOn;
            }
            ButtonIcon{ // Delete all
                implicitHeight: controlPanel.height; implicitWidth: (parent.width-10) / 2;
                radius: 5;
                icon: "root:assets/icons/delete";
                onPushed: Notif.removeAllNotification();
            }
        }
    }
    ClippingRectangle{
        id: bottomPanel;
        width: parent.width;
        height: parent.height - controlPanel.implicitHeight - 10; // -10 because of the margin and some magic
        anchors.top: controlPanel.bottom;
        anchors.topMargin: 5;
        color: "transparent";
        radius: 15;
        ScrollView{
            anchors.fill: parent;
            anchors.leftMargin: 5;
            anchors.rightMargin: 5;
            Column{
                anchors.fill: parent;
                spacing: 5;
                Repeater{ // =====================================================================
                    id: groupRep;
                    model: ScriptModel{
                        values: [...Notif.groups];
                    }
                    delegate: Item{
                        id: app;
                        required property var modelData;
                        required property int index;

                        property bool dropdown: false;
                        property int notifCount: notifRepeater.count;
                        property real notifHeight: notifCount * (70 + 2); // 50 is the height 2 is the spacing

                        height: 20 + (dropdown ? notifHeight : 0);
                        implicitWidth: bottomPanel.width -10; // 5-5 margin on the sides

                        Behavior on height{
                            NumberAnimation{
                                id: anim;
                                duration: 200;
                                easing.type: Easing.OutQuad;
                            }
                        }
                        
                        Rectangle{
                            implicitHeight: 20;
                            implicitWidth: parent.width;
                            color: Colors.overlay0;
                            radius: 20;
                            bottomLeftRadius: dropdown ? 0 : radius;
                            bottomRightRadius: dropdown ? 0 : radius;
                            Rectangle{ // Critical indicator
                                height: parent.height;
                                width: height;
                                color: Colors.red;
                                radius: height;
                                visible: modelData.hasCritical();
                            }
                            Text{
                                id: appName;
                                anchors.centerIn: parent;
                                text: `${app.modelData.appName} - ${app.modelData.list.length}`;
                                color: Colors.text1;
                                font.weight: 550;
                            }
                            IconImage{
                                anchors.right: parent.right;
                                implicitSize: 20;
                                source: dropdown ? "root:assets/icons/arrow_up_black" : "root:assets/icons/arrow_down_black";
                            }
                            MouseArea{anchors.fill: parent; onClicked: dropdown = !dropdown; cursorShape: Qt.PointingHandCursor}

                            Column{
                                anchors.top: parent.bottom;
                                width: parent.width;
                                visible: app.dropdown;
                                spacing: 2;
                                Repeater{
                                    id: notifRepeater;
                                    implicitHeight: (app.dropdown) ? 70 : 0;
                                    implicitWidth: parent.width;
                                    model: ScriptModel{
                                        values: [...app.modelData.list];
                                    }
                                    delegate: Rectangle{
                                        id: notifItem; 
                                        required property var modelData;
                                        required property int index;
                                        property bool isLast: (app.modelData.list.indexOf(modelData) === app.modelData.list.length - 1)  
                                        implicitWidth: parent.width; height: 70
                                        color: Colors.overlay1;

                                        bottomLeftRadius: isLast ? 15 : 0;
                                        bottomRightRadius: isLast ? 15 : 0;
                                        
                                        property bool removing: false;

                                        ParallelAnimation {
                                            running: removing;
                                            NumberAnimation { target: notifItem; property: "x"; to: -width; duration: 250 }
                                            NumberAnimation { target: notifItem; property: "opacity"; to: 0; duration: 200 }
                                            onFinished: app.modelData.removeNotif(modelData);
                                        }

                                        SequentialAnimation on opacity{
                                            NumberAnimation{
                                                from: 0;
                                                to: 1;
                                                easing.type: Easing.InQuad;
                                                duration: 200 + index * 200;
                                            }
                                        }
                                        IconImage{
                                            anchors.top: parent.top; anchors.topMargin: 2;
                                            anchors.right: parent.right; anchors.rightMargin: 10;
                                            implicitSize: 20;
                                            source: "root:assets/icons/delete";
                                            MouseArea{
                                                anchors.fill: parent;
                                                onClicked: notifItem.removing= true;
                                            }
                                        }
                                        Column{
                                            spacing: 2;
                                            width: parent.width;
                                            x: 2; // margin
                                            Row{
                                                spacing: 2;
                                                Rectangle{ // Critical indicator
                                                    height: parent.height;
                                                    width: height;
                                                    color: Colors.red;
                                                    radius: height;
                                                    visible: modelData.isCritical;
                                                }
                                                SlidingText{ // SUMMARY
                                                    width: 130; height: 15; 
                                                    text: modelData.summary;
                                                    textColor: Colors.text;
                                                    fontSize: 8;
                                                }
                                                Text{ // TIME
                                                    text: modelData.timeStr;
                                                    color: Colors.text2;
                                                }
                                            }
                                            ClippingRectangle{
                                                id: bodyClip;
                                                width: parent.width; height: notifItem.height-10;
                                                color: "transparent";
                                                Text{
                                                    width: bodyClip.width; height: bodyClip.height;
                                                    text: modelData.body;
                                                    color: Colors.text;
                                                    font.pointSize: 8;
                                                    wrapMode: Text.WordWrap;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } // App delegate
                }
            }
        }
    }
}