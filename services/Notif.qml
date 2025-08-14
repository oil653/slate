pragma Singleton
pragma ComponentBehavior: Bound

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import qs.components

Singleton{
    id: root;

    // A group is an application, and every application have a list just like root.list that contains the list of notifications
    property list<Group> groups: [];

    // The whole list of notifs are here, generally should not be used
    property list<Notif> list: [];

    // List of currently active popups
    property list<Notif> popups: [];

    // Signal emmited when a new notif appears, contains the notification data the notification data
    signal newNotification(notification: var);

    property bool hasUnseen: false;

    // State property, if set to true notification popups should not appear
    property bool isSilent: false;
    
    
    property bool __notifPanelOpen: (GlobalStates.globalStatesContain("notif") || GlobalStates.globalStatesContain("notification"));
    
    onNewNotification: {
        hasUnseen= (!__notifPanelOpen) ? true : false;
    }

    // Remove notif from both the group and the list
    function removeNotification(notif) {
        notif.notification.dismiss();

        // Remove from main list
        const mainIndex = root.list.indexOf(notif);
        if (mainIndex !== -1) {
            root.list.splice(mainIndex, 1);
        }
        
        // Remove from group list
        const appName = notif.appName || "unknown";
        for (let i = 0; i < root.groups.length; i++) {
            if (root.groups[i].appName === appName) {
                const group = root.groups[i];
                const groupIndex = group.list.indexOf(notif);
                if (groupIndex !== -1) {
                    group.list.splice(groupIndex, 1);

                    // Remove empty groups
                    if (group.list.length === 0) {
                        root.groups.splice(i, 1);
                    }
                }  
                break;  
            }  
        }  
    }
    // remove every notification
    function removeAllNotification() {
        for (let i = 0; i < root.list.length; i++){
            root.list[i].dismiss();
        }

        root.list.splice(0, root.list.length);
        root.groups.splice(0, root.list.length);
    }
    function removePopup(notif: var){
        const index = root.popups.indexOf(notif);
        if (index !== -1){
            root.popups.splice(index, 1);
        }
    }
    function dismissPopup(notif: var){
        const popupIndex = root.popups.indexOf(notif);
        if (popupIndex !== -1){
            root.popups.splice(popupIndex, 1);
        }
        removeNotification(notif);
    }
    

    function addToGroup(notif) {  
        const appName = notif.appName;

        if (!appName){
            appName = "unknown";
        }

        // Find existing group
        let group = null;
        for (let i = 0; i < root.groups.length; i++) {
            if (root.groups[i].appName === appName) {
                group = root.groups[i];
                break;
            }
        }  
          
        // Create new group if doesn't exist  
        if (!group) {
            group = groupComp.createObject(root, {
                appName: appName
            });
            root.groups.push(group);
        }  
          
        // Add notification to group  
        group.list.push(notif);
    }  
    function popupHandler(notif: var) {
        root.popups.push(notif);
        // console.log(root.popups)
        popupTimerComp.createObject(root, {
            targetNotif: notif
        });
        // console.log(root.popups)
    }
    
    Component {  
        id: popupTimerComp  
        Timer {  
            interval: Config.notifPopupTime;
            repeat: false;
            running: true;
            property var targetNotif;
            
            onTriggered: {
                const index = root.popups.indexOf(targetNotif);
                if (index !== -1) {
                    root.popups.splice(index, 1);
                }
                destroy();
            }  
        }  
    }  
    NotificationServer{
        id: server
        imageSupported: true;
        bodyHyperlinksSupported: true;
        bodyImagesSupported: true;
        bodyMarkupSupported: true;
        actionsSupported: true;
        inlineReplySupported: true;
        actionIconsSupported: true;
        keepOnReload: false;
        onNotification: (notification) => {
            notification.tracked = true;
            const notif = notifComp.createObject(root, {
                notification: notification
            });
            root.list.push(notif); // ist
            addToGroup(notif); // group
            root.newNotification(notif); // signal
            if (!root.isSilent){root.popupHandler(notif)}; // Popup
        }
    }

    component Notif: QtObject {
        id: notif

        readonly property date time: new Date();
        readonly property string timeStr: {
            const diff = Time.date.getTime() - time.getTime();
            const m = Math.floor(diff / 60000);
            const h = Math.floor(m / 60);

            if (h < 1 && m < 1)
                return "now";
            if (h < 1)
                return `${m}m`;
            return `${h}h`;
        }

        required property Notification notification;
        readonly property string summary: notification.summary;
        readonly property string body: notification.body;
        readonly property string appIcon: notification.appIcon;
        readonly property string appName: notification.appName;
        readonly property string image: notification.image;
        readonly property int urgency: notification.urgency;
        readonly property list<NotificationAction> actions: notification.actions;

    }

    component Group: QtObject{
        id: group

        required property string appName;
        property list<Notif> list: [];
    }
    
    Component {
        id: groupComp

        Group {}
    }
    Component {
        id: notifComp

        Notif {}
    }
}