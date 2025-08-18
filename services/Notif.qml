pragma Singleton
pragma ComponentBehavior: Bound

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import qs.components

//          FLOW
// Notif sent via dbus -> Notif recived through notifserver
// Notif put into list[], then grouped by appName and put into the correct group, then if !isSilent its put into popup[] 
// POPUP: when expires its removed from popup[].       If it expires before the popup its removed from popup[]; could popup could be hidden and deleted from the NotifPopup

// Notif dismission:
// IF its destroyed by notif server, either by calling dismiss() or expired(), or some apps call replaceId when sending a new notif, making the server delete the older notif. 
    // The notif object must be destroyed from internally and removed from list[], group[], popup[]
// IF the user dismisses or deletes a notif server
    // The notif should be destroyed with an internal call and removed from list[], group[], popup[]

Singleton{
    id: root;

    property list<Group> groups: [];
    property list<Notif> list: [];
    property list<Notif> popups: [];

    signal newNotification(notification: var);
    property bool hasUnseen: false;

    // State property, if set to true notification popups should not appear
    property bool isSilent: false;    
    property bool __notifPanelOpen: (GlobalStates.globalStatesContain("notif") || GlobalStates.globalStatesContain("notification"));
    
    onNewNotification: hasUnseen= (!__notifPanelOpen) ? true : false;

    NotificationServer{
        id: server
        imageSupported: true; bodyHyperlinksSupported: true; bodyImagesSupported: true; bodyMarkupSupported: true;
        actionsSupported: true; inlineReplySupported: true; actionIconsSupported: true; keepOnReload: false;
        onNotification: (notification) => { // --------------------------onNotif
            notification.tracked = true;
            const notif = notifComp.createObject(root, {
                notification: notification
            });
            // push to main list
            root.list.push(notif);

            // group it
            addToGroup(notif);

            // send signal
            root.newNotification(notif);
            
            if (!root.isSilent){root.popupHandler(notif)}; // Popup

        }
    }


    // -------------------------------------------------------------------------------------------------------------------------------------------------------
    function addToGroup(notif) {  // Add to group or make new group
        const appName = notif.appName;

        if (!appName){
            appName = "unknown";
        }

        // Find existing group
        let group = root.groups.find(group => group.appName === appName);

        // Create new group if there is no existing group
        if (!group) {
            group = groupComp.createObject(root, {
                appName: appName
            });
            root.groups.push(group);
        }  

        group.list.push(notif);
    }

    function removeFromGroup(notif) { // Removes element from groups and calls removesEmptyGroup
        let appName = notif.appName;
        
        if (appName === ""){
            appName = "unknown";
        }

        let group = root.groups.find(group => group.appName === appName);

        if (!group){
            return;
        }

        let index = group.list.indexOf(notif);

        if (index === -1){
            return;
        }

        group.list.splice(index, 1);
        removeEmptyGroup(group.appName);
    }
    function removeEmptyGroup(appName:string){ // Removes group only if empty
        let index = root.groups.findIndex(group => group.appName === appName);
        if (index !== -1) {
            if(root.groups[index].list.length === 0){
                root.groups.splice(index, 1);
            }
        }
    }

    function removeNotification(notif) { // Removes notif from list, group, popup
        notif.notification.dismiss();

        // Remove from main list
        const mainIndex = root.list.indexOf(notif);
        if (mainIndex !== -1) {
            root.list.splice(mainIndex, 1);
        }
        
        // Remove from group list
        removeFromGroup(notif);

        if (root.popups.some(popup => popup === notif)){
            removePopup(notif);
        }
    }
    function removeAllNotification(){
        while (root.list.length > 0) {
            removeNotification(root.list[0]);
        }
    }

    function hidePopup(notif: var){
        const index = root.popups.indexOf(notif);
        if (index !== -1){
            root.popups.splice(index, 1);
        }
    }
    function removePopup(notif: var){
        const popupIndex = root.popups.indexOf(notif);
        if (popupIndex !== -1){
            root.popups.splice(popupIndex, 1);
        }
        if (root.list.some(item => item === notif)){
            removeNotification(notif);
        }
    }

    function popupHandler(notif: var) {
        root.popups.push(notif);
        popupTimerComp.createObject(root, {
            targetNotif: notif
        });
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
        readonly property string summary: notification?.summary ?? "";
        readonly property string body: notification?.body ?? "" ;
        readonly property string appIcon: notification?.appIcon ?? "";
        readonly property string appName: notification?.appName ?? "";
        readonly property string image: notification?.image ?? "";
        readonly property int urgency: notification?.urgency ?? false;
        readonly property list<NotificationAction> actions: notification?.actions ?? [];
        readonly property bool isCritical: (urgency === NotificationUrgency.Critical);
        readonly property bool isExpired: {
            if ((notification?.expireTimeout ?? -1) <= 0) return false; // Never expires  
            const now = new Date();  
            const elapsed = (now.getTime() - time.getTime()) / 1000; // Convert to seconds  
            return elapsed >= notification.expireTimeout;  
        }
        
        // Component.onCompleted: console.log("new notif created:", notification, body, summary)
        

        // If the notif server destroys the notification we need to clear this notif object:
        readonly property Connections conn: Connections {
            target: notif.notification.Retainable

            function onDropped(): void {
                // console.log("dropped:", notif.notification, notif.appName);
                root.list.splice(root.list.indexOf(notif), 1);
                removeFromGroup(notif);
            }

            function onAboutToDestroy(): void {
                // console.log("about to destroy:", notif.notification)
                notif.destroy();
            }
        }
    }

    component Group: QtObject{
        id: group

        required property string appName;
        property list<Notif> list: [];
        

        function removeNotif(notif){
            root.removeNotification(notif);
            removeEmptyGroup();
        }
        function hasCritical():bool {
            for (let i = 0; i < list.length; i++){
                if (list[i].isCritical){
                    return true;
                }
            }
            return false;
        }


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