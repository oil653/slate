import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.modules


ShellRoot{
    id: root;
    Variants{
        model: Quickshell.screens;
        delegate: Component{
            PanelWindow{
                id: panelRoot;
                property var modelData: modelData;
                screen: modelData;
                anchors.top: true;

                implicitWidth: modelData.width - Config.margin;
                implicitHeight: Config.height;
                color: "transparent";


                Component{
                    id: workspaceLoader;
                    Workspace{
                        implicitWidth: 100;
                        implicitHeight: Config.height -2;
                        currentMonitor: (Config.isWorkspacesPerMonitor) ? panelRoot.modelData.name : "";
                    }
                }
                Component{
                    id: clockLoader;
                    Clock{
                        // implicitWidth: 200;
                        implicitHeight: Config.height -2;
                        anchors.centerIn: parent;
                    }
                }
                Rectangle{
                    anchors.fill: parent;

                    color: Colors.background;
                    opacity: Config.opacity;

                    topLeftRadius: Config.radius;
                    topRightRadius: Config.radius;
                    bottomLeftRadius: Config.bottomRadius ? Config.radius : 0;
                    bottomRightRadius: Config.bottomRadius ? Config.radius : 0;

                    Item{
                        id: widgetLayout;
                        anchors.fill: parent;
                        anchors.leftMargin: Config.radius;
                        anchors.rightMargin: Config.radius;
                        function getCurrentWidget(x) { // Returns the corresponding loader from the passed in string
                            switch (x) {
                                case "workspace": return workspaceLoader;
                                case "clock": return clockLoader;
                                default: return null;
                            }
                        }
                        Row { // Left panel
                            id: leftPanel;
                            spacing: 0;
                            height: parent.height;
                            anchors.left: parent.left;
                            Repeater {
                                model: Widgets.leftWidgetList;
                                delegate: Item {
                                    id: dynamicItem;
                                    implicitHeight: widgetLayout.height;
                                    implicitWidth: loader.item ? loader.item.implicitWidth : 0;
                                    property string widgetName: modelData;
                                    property bool isFirst: (index === 0); // True if the first element in the row
                                    Loader {
                                        id: loader;
                                        anchors.centerIn: parent;
                                        active: widgetName !== "";
                                        sourceComponent: widgetLayout.getCurrentWidget(widgetName);
                                        MouseArea {
                                            // I tried a lots of thing to get the relative position of the delegate to the bar but i couldnt.
                                            // So now the popups will be handled by panel rather than individually from the widgets 
                                            // and popup could appear under the panels, rather than the widgets. Bit junky but its what we have.
                                            anchors.fill: parent;
                                            property bool hasPopup: !(widgetName === "weather" || widgetName === "workspace");
                                            hoverEnabled: hasPopup ? true : false;
                                            cursorShape: hasPopup ? Qt.PointingHandCursor : Qt.ArrowCursor;
                                            acceptedButtons: hasPopup ? Qt.LeftButton | Qt.RightButton : Qt.NoButton;
                                            onClicked: {
                                                // Set the left popup to the correct element
                                                GlobalStates.leftPopup = (GlobalStates.leftPopup === "") ? widgetName : "";
                                                GlobalStates.leftPopupAnchor = dynamicItem.isFirst;
                                                // Clear all the other popup
                                                GlobalStates.middlePopup = "";
                                                GlobalStates.rightPopup = "";
                                                GlobalStates.rightPopupAnchor = false;

                                                // console.log("Left panel popup:",GlobalStates.leftPopup);
                                                // console.log("Left panel popup anchor:",GlobalStates.leftPopupAnchor);
                                                // console.log("Middle panel popup:",GlobalStates.middlePopup);
                                                // console.log("Right panel popup:",GlobalStates.rightPopup);
                                                // console.log("Right panel popup anchor:",GlobalStates.rightPopupAnchor, "\n");
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Row { // Middle panel
                            id: middlePanel;
                            spacing: 0;
                            height: parent.height;
                            anchors.centerIn: parent;
                            Repeater {
                                model: Widgets.middleWidgetList;
                                delegate: Item {
                                    id: dynamicItem;
                                    implicitHeight: widgetLayout.height;
                                    implicitWidth: loader.item ? loader.item.implicitWidth : 0;
                                    property string widgetName: modelData;
                                    Loader {
                                        id: loader;
                                        anchors.centerIn: parent;
                                        active: widgetName !== "";
                                        sourceComponent: widgetLayout.getCurrentWidget(widgetName);
                                        MouseArea {
                                            anchors.fill: parent;
                                            // Not all widgets have popup
                                            property bool hasPopup: !(widgetName === "weather" || widgetName === "workspace");
                                            hoverEnabled: hasPopup ? true : false;
                                            cursorShape: hasPopup ? Qt.PointingHandCursor : Qt.ArrowCursor;
                                            acceptedButtons: hasPopup ? Qt.LeftButton | Qt.RightButton : Qt.NoButton;
                                            onClicked: {
                                                // Set the middle popup to the correct element
                                                GlobalStates.middlePopup = (GlobalStates.middlePopup === "") ? widgetName : "";
                                                // Clear all the other popup
                                                GlobalStates.leftPopup = "";
                                                GlobalStates.leftPopupAnchor = false;
                                                GlobalStates.rightPopup = "";
                                                GlobalStates.rightPopupAnchor = false;

                                                // console.log("Left panel popup:",GlobalStates.leftPopup);
                                                // console.log("Left panel popup anchor:",GlobalStates.leftPopupAnchor);
                                                // console.log("Middle panel popup:",GlobalStates.middlePopup);
                                                // console.log("Right panel popup:",GlobalStates.rightPopup);
                                                // console.log("Right panel popup anchor:",GlobalStates.rightPopupAnchor, "\n");
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Row { // Right panel
                            id: rightPanel;
                            spacing: 0;
                            height: parent.height;
                            anchors.right: parent.right;
                            layoutDirection: Qt.RightToLeft;
                            Repeater {
                                model: Widgets.rightWidgetList;
                                delegate: Item {
                                    id: dynamicItem;
                                    implicitHeight: widgetLayout.height;
                                    implicitWidth: loader.item ? loader.item.implicitWidth : 0;
                                    property string widgetName: modelData;
                                    property bool isFirst: (index === 0);
                                    Loader {
                                        id: loader;
                                        anchors.centerIn: parent;
                                        active: widgetName !== "";
                                        sourceComponent: widgetLayout.getCurrentWidget(widgetName);
                                        MouseArea {
                                            anchors.fill: parent;
                                            property bool hasPopup: !(widgetName === "weather" || widgetName === "workspace");
                                            hoverEnabled: hasPopup ? true : false;
                                            cursorShape: hasPopup ? Qt.PointingHandCursor : Qt.ArrowCursor;
                                            acceptedButtons: hasPopup ? Qt.LeftButton | Qt.RightButton : Qt.NoButton;
                                            onClicked: {
                                                // Set the right popup to the correct element
                                                GlobalStates.rightPopup = (GlobalStates.rightPopup === "") ? widgetName : "";
                                                GlobalStates.rightPopupAnchor = dynamicItem.isFirst;
                                                // Clear all the other popup
                                                GlobalStates.middlePopup = "";
                                                GlobalStates.leftPopup = "";
                                                GlobalStates.leftPopupAnchor = false;

                                                // console.log("Left panel popup:",GlobalStates.leftPopup);
                                                // console.log("Left panel popup anchor:",GlobalStates.leftPopupAnchor);
                                                // console.log("Middle panel popup:",GlobalStates.middlePopup);
                                                // console.log("Right panel popup:",GlobalStates.rightPopup);
                                                // console.log("Right panel popup anchor:",GlobalStates.rightPopupAnchor, "\n");
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                LazyLoader{ // Clock widget loader
                    active: (GlobalStates.leftPopup === "clock" || GlobalStates.rightPopup === "clock" || GlobalStates.middlePopup === "clock");
                    Calendar{
                        anchors.top: true;
                        anchors.left: GlobalStates.leftPopupAnchor;
                        anchors.right: GlobalStates.rightPopupAnchor;
                        margins.left: Config.margin;
                        margins.right: Config.margin;
                    }
                }
            }
        }
    }
}