pragma Singleton
pragma ComponentBehavior: Bound

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton{
    // property bool onBattery: UPower.onBattery;
    property bool onBattery: true;
    
    property var source: UPower.displayDevice
    property bool sourceIsCharging: (source.changeRate > 0);

    property string batteryIcon: {
        if(!onBattery){
            return "root:assets/icons/battery/power";
        }
        if(!source){
            return "root:assets/icons/question_mark"
        }
        return icon(source.percentage);
    };

    function icon(percentage: real): string{
        const icon = "root:assets/icons/battery/"
        const prc = percentage * 100;
        if (prc < 5) return icon + "alert";
        if (prc < 15) return icon + "10";
        if (prc < 25) return icon + "20";
        if (prc < 40) return icon + "35";
        if (prc < 60) return icon + "50";
        if (prc < 80) return icon + "75";
        if (prc < 100) return icon + "90";
        if (prc === 100) return icon + "100";
        return icon + "alert";
    }
    function isCharging(battery: var): bool{
        return battery.changeRate > 0
    }

    
    Component.onCompleted: {
        // if(source.ready){console.log(source.percentage)}
    }
}