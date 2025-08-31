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
    id: root;  
    property real scale: Config.scale;   
  
    implicitHeight: (5 * root.scale + modeSlider.height   
        + ((deviceRep.count < 5) ? deviceRep.count * (30 * root.scale + deviceCol.spacing) : 5 * (30 * root.scale + deviceCol.spacing))   
        + ((deviceRep.count > 0) ? devices.anchors.topMargin : 0)) * root.scale;  
    implicitWidth: 200 * root.scale;  
      
    Item{ // modeSlider  
        id: modeSlider;  
        anchors.top: parent.top;  
        width: parent.width;  
        height: 35 * root.scale;  
          
        Rectangle{  
            id: sliderBase;  
            anchors.centerIn: parent;  
            width: parent.width - 25 * root.scale;  
            height: parent.height - 20 * root.scale;  
            radius: 20 * root.scale;  
            color: Colors.surface0;  
              
            Rectangle{  
                id: slidingCircle;  
                anchors.verticalCenter: parent.verticalCenter;  
                width: 30 * root.scale;   
                height: 30 * root.scale;  
                radius: 10 * root.scale;  
                color: Colors.overlay0;  
                  
                MouseArea{  
                    anchors.fill: parent;  
                    drag.target: slidingCircle;  
                    drag.axis: Drag.XAxis;  
                    drag.minimumX: 0;  
                    drag.maximumX: PowerProfiles.hasPerformanceProfile ? sliderBase.width - slidingCircle.width : 112 * root.scale  
                }  
                  
                onXChanged: {  
                    if (x <= 40 * root.scale){  
                        x = 0;   
                        PowerProfiles.profile = PowerProfile.PowerSaver;  
                    } else if (x <= 112 * root.scale){  
                        x = (parent.width - width) / 2;  
                        PowerProfiles.profile = PowerProfile.Balanced;  
                    } else if (x > 112 * root.scale && PowerProfiles.hasPerformanceProfile){  
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
                anchors.verticalCenter: parent.verticalCenter;   
                anchors.left: parent.left;  
                width: 28 * root.scale;   
                height: 28 * root.scale;  
                radius: 15 * root.scale;   
                z: 1;  
                color: (PowerProfiles.profile === PowerProfile.PowerSaver) ? Colors.overlay0 : Colors.overlay1;  
                  
                IconImage{  
                    anchors.centerIn: parent;  
                    implicitSize: (parent.height - 5 * root.scale)  
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
                anchors.verticalCenter: parent.verticalCenter;   
                anchors.centerIn: parent;  
                width: 28 * root.scale;   
                height: 28 * root.scale;  
                radius: 15 * root.scale;   
                z: 1;  
                color: (PowerProfiles.profile === PowerProfile.Balanced) ? Colors.overlay0 : Colors.overlay1;  
                  
                IconImage{  
                    anchors.centerIn: parent;  
                    implicitSize: (parent.height - 10 * root.scale)  
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
                anchors.verticalCenter: parent.verticalCenter;   
                anchors.right: parent.right;  
                width: 28 * root.scale;   
                height: 28 * root.scale;  
                radius: 15 * root.scale;   
                z: 1;  
                color: (PowerProfiles.profile === PowerProfile.Performance) ? Colors.overlay0 : Colors.overlay1;  
                  
                IconImage{  
                    anchors.centerIn: parent;  
                    implicitSize: (parent.height - 5 * root.scale)  
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
      
    ScrollView{  
        id: devices;  
        anchors.top: modeSlider.bottom;   
        anchors.bottom: parent.bottom;  
        anchors.left: parent.left;   
        anchors.right: parent.right;  
        anchors.leftMargin: 5 * root.scale;   
        anchors.rightMargin: 5 * root.scale;   
        anchors.topMargin: 4 * root.scale;  
          
        Column{  
            id: deviceCol;  
            anchors.fill: parent;  
            spacing: 2 * root.scale;  
              
            Repeater{  
                id: deviceRep;  
                model: ScriptModel{values: [...UPower.devices.values.filter(device => device.model && device.model.trim() !== "")]}  
                  
                Rectangle{  
                    id: device;  
                    required property var modelData;  
                    required property int index;  
                    property bool isFirst: index === 0;  
                    property bool isLast: (index + 1) === deviceRep.count;  
                      
                    topLeftRadius: isFirst ? 10 * root.scale : 0;  
                    topRightRadius: isFirst ? 10 * root.scale : 0;  
                    bottomLeftRadius: isLast ? 10 * root.scale : 0;  
                    bottomRightRadius: isLast ? 10 * root.scale : 0;  
  
                    width: deviceCol.width;   
                    height: 30 * root.scale  
                    color: Colors.overlay1;  
                      
                    Row{  
                        anchors.fill: parent;  
                          
                        IconImage{  
                            implicitSize: (parent.height - 3 * root.scale);  
                            source: Power.deviceIcon(modelData);  
                        }  
                          
                        Column{  
                            width: 100 * root.scale;  
                            height: parent.height;  
                              
                            Text{  
                                id: deviceName;  
                                text: modelData.model  
                                font.pixelSize: 12 * root.scale;  
                                color: Colors.text2;  
                            }  
                              
                            Row{  
                                height: parent.height - deviceName.implicitHeight;   
                                  
                                Row{ // health indicator  
                                    visible: modelData.healthSupported ?? false;  
                                    height: parent.height;   
                                    width: 35 * root.scale;  
                                      
                                    IconImage{  
                                        implicitSize: (parent.height - 2 * root.scale);  
                                        source: "root:assets/icons/battery/healt"  
                                    }  
                                      
                                    Text{  
                                        id: healthPerc;  
                                        property real perc: modelData.healthPercentage ?? -1;   
                                        text: `${Math.floor(perc)}%`;  
                                        color: (perc > 90) ? Colors.green : (perc >= 80) ? Colors.yellow : Colors.red;  
                                        font.pixelSize: 10 * root.scale  
                                    }  
                                }  
                                  
                                Text{  
                                    property real timeTo: modelData.timeToFull + modelData.timeToEmpty;  
                                    visible: timeTo !== 0;  
  
                                    text: Power.formatTime(timeTo);  
                                    color: (Power.isCharging(modelData)) ? Colors.green : Colors.red;  
                                    font.pixelSize: 10 * root.scale;  
                                    width: 25 * root.scale  
                                }  
                                  
                                IconImage{  
                                    source: Power.icon(modelData.percentage);  
                                    implicitSize: 13 * root.scale;  
                                }  
                                  
                                Text{  
                                    text: `${Math.floor(modelData.percentage * 100)}%`  
                                    color: Colors.text2;  
                                    font.pixelSize: 10 * root.scale;  
                                }  
                            }  
                        }  
                    }  
                }  
            }  
        }  
    }  
}