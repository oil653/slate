pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
    property real scale: adapter.scale; // Scales of some popups
    property real height: adapter.height; // Panel height
    property real margin: adapter.margin // Panel margin from the side of the screens  
    property real opacity: adapter.opacity; // Opacity of the bar background
    property real radius: adapter.radius; // Radius of the main bar
    property bool bottomRadius: adapter.bottomRadius; // If set to true the bottom sides will have radius applyed
    property real rowSpacing: adapter.rowSpacing; // Spacing between the widgets
    property real widgetHeight: adapter.widgetHeight; // Widgets sizes are calculated like bar height - widgetHeight
    
    // Popups general
    property bool closeOnOutclick: adapter.closeOnOutclick; // If the popups should close if the user click outside the popups
    property real popupAnimationTime: adapter.popupAnimationTime; // Defines how long should the animation on popups be

    // Workspaces
    property bool minimalWorkspace: adapter.minimalWorkspace; // Defines the mode of the workspace 
    property bool isWorkspacesPerMonitor: adapter.isWorkspacesPerMonitor // If false all open worksapces will show on all monitors

    // Clock
    property string dateFormat: adapter.dateFormat; // Full list of format specifiers on wiki

    // Media
    property real mediaPlayerWidth: adapter.mediaPlayerWidth; // The width of the player

    // Notification
    property int notifPopupTime: adapter.notifPopupTime; // How much time the notification popups should be shown

    // Keyboard
    // for a list of variant run: grep 'xkb_symbols' /usr/share/X11/xkb/symbols/<language/layout name> | grep -v 'default\|basic'
    // Note that when slate is launched it sets the first keyboard state, so the first should be your main one
    property var keyboard: adapter.keyboard;

    // Systray
    property bool showAllTray: adapter.showAllTray; // If set to true all systrays will be show (even if it reports that is shouldnt be visible), some apps doesnt report they status correctly


    // ====================
    function adapterReload(){
        fileView.reload()
    }
    function adapterOverwrite(){
        fileView.writeAdapter()
    }

    FileView{
        id: fileView;
        path: Quickshell.shellPath("config/config.json");

        watchChanges: true;
        preload: true;
        
        onFileChanged: {
            reload();
            console.log("Main config file changed, reloading adapter")
        }
        onAdapterUpdated: {
            writeAdapter();
            console.log("Main config adapter updated, writing adapter to file");
        }

         // If file is empty it writes the defaults  
        onLoaded: {
            if (data().length === 0 || text().trim() === "" || text().trim() === "{}") {  
                console.log("Main config file is empty, writing defaults");  
                writeAdapter();  
            }  
        }  
        
        // If file doesnt exists it tries to create a new one with the default parameters in it
        // Not too reliable
        onLoadFailed: function(error) {  
            if (error === FileViewError.FileNotFound) {  
                console.log("Main config file not found, attempting to create one with defaults");  
                writeAdapter();  
            }  
        }  
        
        JsonAdapter {
            id: adapter;
            property real height: 30;
            property real margin: 30;
            property real opacity: 1;
            property real radius: 15;
            property bool bottomRadius: true;
            property bool minimalWorkspace: false;
            property bool isWorkspacesPerMonitor: true;
            property string dateFormat: "hh:mm <b>·</b> dddd, MMM d";
            property real rowSpacing: 10;
            property real mediaPlayerWidth: 200;
            property int notifPopupTime: 3000;
            property var keyboard: [
                {
                    layout: "us",
                    variant: "basic" 
                },
                {
                    layout: "hu",
                    variant: "qwerty"
                }
            ]
            property real widgetHeight: 5;
            property real scale: 1.2;
            property bool closeOnOutclick: true;
            property real popupAnimationTime: 150;
            property bool showAllTray: false;
        }
    }
}