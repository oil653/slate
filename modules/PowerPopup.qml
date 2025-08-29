import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.UPower
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

PopupPos{
    implicitHeight: 5 + modeSlider.height + (Power.onBattery ? (batteryInfoBar.height + batteryInfoBar.topMargin) : 0) 
        + ((deviceRep.count < 5) ? deviceRep.count * (30 + deviceCol.spacing) : 5 * (device.height + deviceCol.spacing)) 
        + ((deviceRep.count > 0) ? devices.anchors.topMargin : 0);
    implicitWidth: 200;
    Item{ // modeSlider
        id: modeSlider;
        anchors.top: parent.top;
        width: parent.width;
        height: 35;
        Rectangle{
            id: sliderBase;
            anchors.centerIn: parent;
            width: parent.width - 25;
            height: parent.height - 20;
            radius: 20;
            color: Colors.surface0;
            Rectangle{
                id: slidingCircle;
                anchors.verticalCenter: parent.verticalCenter;
                width: 30; height: 30;
                radius: 10;
                color: Colors.overlay0;
                MouseArea{
                    anchors.fill: parent;
                    drag.target: slidingCircle;
                    drag.axis: Drag.XAxis;
                    drag.minimumX: 0;
                    drag.maximumX: PowerProfiles.hasPerformanceProfile ? sliderBase.width - slidingCircle.width : 112
                }
                onXChanged: {
                    if (x <= 40){
                        x = 0; 
                        PowerProfiles.profile = PowerProfile.PowerSaver;
                    } else if (x <= 112){
                        x = (parent.width - width) / 2;
                        PowerProfiles.profile = PowerProfile.Balanced;
                    } else if (x > 112 && PowerProfiles.hasPerformanceProfile){
                        x = parent.width - width
                        PowerProfiles.profile = PowerProfile.Performance;
                    }
                }
                Component.onCompleted: {
                    if (PowerProfiles.profile === PowerProfile.PowerSaver){
                        x = 0;
                    } else if (PowerProfiles.profile === PowerProfile.Balanced){
                        x = (parent.width - width) / 2;
                    } else if (PowerProfiles.profile === PowerProfile.Performance){
                        x = parent.width - width;
                    }
                }
            }
            Rectangle{ // ECO
                id: slideLeft;
                anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left;
                width: 28; height: 28;
                radius: 15; z: 1;
                color: (PowerProfiles.profile === PowerProfile.PowerSaver) ? Colors.overlay0 : Colors.overlay1;
                IconImage{
                    anchors.centerIn: parent;
                    implicitSize: parent.height - 5
                    source: "root:assets/icons/battery/eco";
                }
                MouseArea{
                    anchors.fill: parent;
                    enabled: !(slidingCircle.x === 0); 
                    onClicked: slidingCircle.x = 0;
                }
            }
            Rectangle{ // BAL
                id: slideMid;
                anchors.verticalCenter: parent.verticalCenter; anchors.centerIn: parent;
                width: 28; height: 28;
                radius: 15; z: 1;
                color: (PowerProfiles.profile === PowerProfile.Balanced) ? Colors.overlay0 : Colors.overlay1;
                IconImage{
                    anchors.centerIn: parent;
                    implicitSize: parent.height - 10
                    source: "root:assets/icons/battery/balanced";
                }
                MouseArea{
                    anchors.fill: parent;
                    enabled: !(slidingCircle.x === (sliderBase.width - slidingCircle.width) / 2); 
                    onClicked: slidingCircle.x = (sliderBase.width - slidingCircle.width) / 2;
                }
            }
            Rectangle{ // PERF
                id: slideRight;
                anchors.verticalCenter: parent.verticalCenter; anchors.right: parent.right;
                width: 28; height: 28;
                radius: 15; z: 1;
                color: (PowerProfiles.profile === PowerProfile.Performance) ? Colors.overlay0 : Colors.overlay1;
                IconImage{
                    anchors.centerIn: parent;
                    implicitSize: parent.height - 5
                    source: "root:assets/icons/battery/performance";
                }
                MouseArea{
                    anchors.fill: parent;
                    enabled: (!(slidingCircle.x === sliderBase.width - slidingCircle.width) && PowerProfiles.hasPerformanceProfile); 
                    onClicked: slidingCircle.x = sliderBase.width - slidingCircle.width;
                }
            }
        }
    }
    Row{
        id: batteryInfoBar
        visible: Power.onBattery;
        anchors.top: modeSlider.bottom; anchors.right: parent.right; anchors.left: parent.left;
        anchors.leftMargin: 5; anchors.rightMargin: 5; anchors.topMargin: 5;
        height: 15;
        Row{ // health indicator
            visible: Power.source.healthSupported ?? false;
            height: parent.height; width: 20 + healthPerc.implicitWidth;
            IconImage{
                implicitSize: parent.height - 2;
                source: "root:assets/icons/battery/healt"
            }
            Text{
                id: healthPerc;
                property real perc: Power.source.healthPercentage * 100 ?? -1; 
                text: `${perc}%`;
                color: (perc > 90) ? Colors.green : (perc >= 80) ? Colors.yellow : Colors.red;
            }
        }
        IconImage{ // heat throttle idicator
            visible: PowerProfiles.degradationReason === PowerProfile.HighTemperature;
            implicitSize: parent.height;
            source: "root:assets/icons/heat"
        }
        Text{
            visible: UPower.onBattery;
            property real rate: Power.source.changeRate; 
            text: rate + "W";
            color: (rate > 0) ? Colros.green : (rate < 0) ? Colors.red : Colors.text;
        }
    }
    ScrollView{
        id: devices;
        anchors.top: (Power.onBattery) ? batteryInfoBar.bottom : modeSlider.bottom; anchors.bottom: parent.bottom;
        anchors.left: parent.left; anchors.right: parent.right;
        anchors.leftMargin: 5; anchors.rightMargin: 5; anchors.topMargin: 4;
        Column{
            id: deviceCol;
            anchors.fill: parent;
            spacing: 2;
            Repeater{
                id: deviceRep;
                model: ScriptModel{values: [...UPower.devices.values.filter(device => !device.isLaptopBattery)]}
                Rectangle{
                    id: device;
                    required property var modelData;
                    required property int index;
                    property bool isFirst: index === 0;
                    property bool isLast: (index + 1) === deviceRep.count;
                    
                    topLeftRadius: isFirst ? 10 : 0;
                    topRightRadius: isFirst ? 10 : 0;
                    bottomLeftRadius: isLast ? 10 : 0;
                    bottomRightRadius: isLast ? 10 : 0;

                    width: deviceCol.width; height: 30
                    color: Colors.overlay1;
                    Row{
                        anchors.fill: parent;
                        IconImage{
                            implicitSize: parent.height -2;
                            source: Power.deviceIcon(modelData);
                        }
                        Column{
                            width: 100;
                            height: parent.height;
                            Text{
                                id: deviceName;
                                text: modelData.model
                                font.pixelSize: 12;
                                color: Colors.text2;
                            }
                            Row{
                                height: parent.height - deviceName.implicitHeight; 
                                Row{ // health indicator
                                    visible: modelData.healthSupported ?? false;
                                    height: parent.height; width: 20 + healthPerc.implicitWidth;
                                    IconImage{
                                        implicitSize: parent.height - 2;
                                        source: "root:assets/icons/battery/healt"
                                    }
                                    Text{
                                        id: healthPerc;
                                        property real perc: modelData.healthPercentage * 100 ?? -1; 
                                        text: `${perc}%`;
                                        color: (perc > 90) ? Colors.green : (perc >= 80) ? Colors.yellow : Colors.red;
                                        font.pixelSize: 10
                                    }
                                }
                                Text{
                                    visible: timeTo !== 0;
                                    property real timeTo: modelData.timeToFull + modelData.timeToEmpty
                                    text: Power.formatTime(timeTo);
                                    color: (Power.isCharging(modelData)) ? Colors.green : Colors.red;
                                    font.pixelSize: 10;
                                }
                                IconImage{
                                    source: Power.icon(modelData.percentage);
                                    implicitSize: 13;
                                }
                                Text{
                                    text: `${modelData.percentage * 100}%`
                                    color: Colors.text2;
                                    font.pixelSize: 10;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}