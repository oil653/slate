pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
    property real height: adapter.height; // Panel height
    property real margin: adapter.margin // Panel margin from the side of the screens  
    property real opacity: adapter.opacity; // Opacity of the bar
    property real radius: adapter.radius; // Radius of the main bar
    property bool bottomRadius: adapter.bottomRadius; // If set to true the bottom sides will have radius applyed
    property real rowSpacing: adapter.rowSpacing; // Spacing between the widgets
    
    // Global 
    property bool popupTopRadius: adapter.popupTopRadius; // if set to true the popups will also have radius on the top. Reccomended to be the same as bottomRadius;

    // Workspaces
    property bool minimalWorkspace: adapter.minimalWorkspace; // Defines the mode of the workspace 
    property bool isWorkspacesPerMonitor: adapter.isWorkspacesPerMonitor // If false all open worksapces will show on all monitors

    // Clock
    property string dateFormat: adapter.dateFormat; // Full list of format specifiers on wiki

    // Media
    property real mediaPlayerWidth: adapter.mediaPlayerWidth;

    // Notification
    property int notifPopupTime: adapter.notifPopupTime; // How much time the popups should be shown

    // Keyboard
    // for a list of variant run: grep 'xkb_symbols' /usr/share/X11/xkb/symbols/<language/layout name> | grep -v 'default\|basic'
    // Note that when slate is launched it sets the first keyboard state, so the first should be your main one
    property var keyboard: adapter.keyboard;

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
            property bool popupTopRadius: false;
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
            property bool autoKybApply: false;
        }
        
    }
}