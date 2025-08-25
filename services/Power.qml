pragma Singleton
pragma ComponentBehavior: Bound

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton{
    property bool onBattery: UPower.onBattery;
    
    property var source: {
        for (let i = 0; i < UPower.devices.count; i++) {  
            let device = UPower.devices.at(i)  
            if (device.isLaptopBattery) {
                return device;
            }
        }
    }

    property string batteryIcon: {
        const icon = "root:assets/icons/battery/";
        if(!onBattery){
            return icon+"power";
        }
        if(!source){
            return "root:assets/icon/unkown"
        }
        return icon(source.percentage);
    };

    function icon(percentage: real): string{
        if (percentage < 5) return icon + "alert";
        if (percentage < 15) return icon + "10";
        if (percentage < 25) return icon + "20";
        if (percentage < 40) return icon + "35";
        if (percentage < 60) return icon + "50";
        if (percentage < 80) return icon + "75";
        if (percentage < 100) return icon + "90";
        if (percentage === 100) return icon + "100";
        return icon + "alert";
    }
    Component.onCompleted: if(source){console.log("Currently used battery path:", source.nativePath)}
}