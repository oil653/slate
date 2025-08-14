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
    readonly property real defaultHeight: 300;
    property real notificationPanelHeight: 0;

    implicitHeight: defaultHeight + notificationPanelHeight; 
    implicitWidth: 250;
    Component.onCompleted: Notif.hasUnseen = false;
    Rectangle{
        anchors.fill: parent;
        radius: 15;
        topLeftRadius: Config.popupTopRadius ? 15 : 0;
        topRightRadius: Config.popupTopRadius ? 15 : 0;
        color: Colors.surface0;
        Item{ // Control panel
            id: controlPanel;
            anchors.top: parent.top;
            anchors.left: parent.left; anchors.right: parent.right;
            anchors.topMargin: 5; anchors.leftMargin: 5;
            implicitHeight: 40;
            Row{
                anchors.fill: parent;
                spacing: 5;
                ToggleIcon{ // Silent on off
                    implicitHeight: 40; implicitWidth: (parent.width-10) / 2; // -10 because of the two margin on the side
                    radius: 5;
                    onIcon: "root:assets/icons/bell_silent_on";
                    offIcon: "root:assets/icons/bell_silent_off";
                    isOn: Notif.isSilent;
                    onToggle: Notif.isSilent = isOn;
                }
                ButtonIcon{ // Delete all
                    implicitHeight: 40; implicitWidth: (parent.width-10) / 2;
                    radius: 5;
                    icon: "root:assets/icons/delete";
                    onPushed: Notif.removeAllNotification();
                }
            }
        }
        Item{
            id: bottomPanel;
            width: parent.width;
            height: parent.height - controlPanel.implicitHeight - 10; // -10 because of the margin and some magic
            anchors.top: controlPanel.bottom;
            anchors.topMargin: 5;
            ScrollView{
                anchors.fill: parent;
                anchors.leftMargin: 5;
                anchors.rightMargin: 5;
                Column{
                    anchors.fill: parent;
                    spacing: 5;
                    Repeater{ // =====================================================================
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

                            implicitHeight: 20 + (dropdown ? notifHeight : 0);
                            implicitWidth: bottomPanel.width -10; // 5-5 margin on the sides
                            
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
                                            implicitWidth: parent.width; height: 70;
                                            color: Colors.overlay1;
                                            IconImage{
                                                anchors.top: parent.top; anchors.topMargin: 2;
                                                anchors.right: parent.right; anchors.rightMargin: 10;
                                                implicitSize: 20;
                                                source: "root:assets/icons/delete";
                                                MouseArea{
                                                    anchors.fill: parent;
                                                    onClicked: app.modelData.removeNotif(modelData);
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
                                                    SlidingText{
                                                        width: 130; height: 15; 
                                                        text: modelData.summary;
                                                        textColor: Colors.text;
                                                        fontSize: 10;
                                                    }
                                                    Text{
                                                        text: modelData.timeStr;
                                                        color: Colors.text2;
                                                    }
                                                }
                                                ClippingRectangle{
                                                    id: bodyClip;
                                                    width: parent.width; height: notifItem.height-10; // 30 on minimal or notifItem.height-10
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
} // staircase of }