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
                        // implicitWidth: 100;
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
                        function popupDebugPrint(){ // Prints all values from GlobalStates that relates to popups
                            // console.log("leftPopup:", GlobalStates.leftPopup, "\n leftElementWidth", GlobalStates.leftElementWidth, "\n leftPopupCallerIndex", GlobalStates.leftPopupCallerIndex, "\n");
                            // console.log("rightPopup:", GlobalStates.rightPopup, "\n rightElementWidth", GlobalStates.rightElementWidth, "\n rightPopupCallerIndex", GlobalStates.rightPopupCallerIndex, "\n");
                            // console.log("middlePopup:", GlobalStates.middlePopup, "\n");
                        }
                        Row { // Left panel
                            id: leftPanel;
                            spacing: Config.rowSpacing;
                            height: parent.height;
                            anchors.left: parent.left;
                            Repeater {
                                model: Widgets.leftWidgetList;
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
                                            property bool hasPopup: !(widgetName === "weather" || widgetName === "workspace");
                                            hoverEnabled: hasPopup ? true : false;
                                            cursorShape: hasPopup ? Qt.PointingHandCursor : Qt.ArrowCursor;
                                            acceptedButtons: hasPopup ? Qt.LeftButton | Qt.RightButton : Qt.NoButton;
                                            onClicked: {
                                                GlobalStates.leftPopup = (GlobalStates.leftPopup === "") ? widgetName : "";
                                                GlobalStates.leftPopupCallerIndex = index;
                                                // Clear all the other popups
                                                GlobalStates.middlePopup = "";
                                                GlobalStates.rightPopup = "";

                                                widgetLayout.popupDebugPrint();
                                            }
                                        }
                                    }
                                    Component.onCompleted:{
                                        GlobalStates.leftElementWidth[index] = dynamicItem.width;
                                    }
                                }
                            }
                        }
                        Row { // Middle panel
                            id: middlePanel;
                            spacing: Config.rowSpacing;
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

                                                widgetLayout.popupDebugPrint();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Row { // Right panel
                            id: rightPanel;
                            spacing: Config.rowSpacing;
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
                                    Component.onCompleted:{
                                        GlobalStates.rightElementWidth[index] = dynamicItem.width;
                                    }
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
                                                GlobalStates.rightPopup = (GlobalStates.rightPopup === "") ? widgetName : "";
                                                GlobalStates.leftPopupCallerIndex = index;
                                                // Clear all the other popups
                                                GlobalStates.middlePopup = "";
                                                GlobalStates.leftPopup = "";

                                                widgetLayout.popupDebugPrint();
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
                    Calendar{}
                }
            }
        }
    }
}