pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
    id: root;
    // ../config/widgets.json
    property var leftWidgetList: [];
    property var middleWidgetList: [];
    property var rightWidgetList: [];
    
    Component.onCompleted: {
        root.refresh();
    }
    onRefresh: {
        leftWidgetList = adapter.leftWidgetList;
        middleWidgetList = adapter.middleWidgetList;
        rightWidgetList = adapter.rightWidgetList;
    }


    function adapterReload(){
        fileView.reload();
    }
    function adapterOverwrite(){
        fileView.writeAdapter();
    }

    signal refresh;

    FileView{
        id: fileView;
        path: Quickshell.shellPath("config/widgets.json");

        watchChanges: true;
        preload: true;
        
        onFileChanged: {
            reload();
            root.refresh();
            console.log("Widget config file changed, reloading adapter");
        }
        onAdapterUpdated: {
            writeAdapter();
            console.log("Widget config adapter updated, writing adapter to file");
        }

        // If file is empty write default to it otherwise read refresh()
        onLoaded: {  
            if (data().length === 0 || text().trim() === "" || text().trim() === "{}") { 
                console.log("Widget config file is empty, writing defaults"); 
                writeAdapter(); 
            } else {
                root.refresh();
            }  
        }
        
        // If file doesnt exists it tries to create a new one with the default parameters in it
        // Not too reliable
        onLoadFailed: function(error) {  
            if (error === FileViewError.FileNotFound) {  
                console.log("Widget config file not found, attempting to create one with defaults");  
                writeAdapter();  
            }  
        }  
        
        JsonAdapter {
            id: adapter;
            property var leftWidgetList: [];
            property var middleWidgetList: [];
            property var rightWidgetList: [];
        }
        
    }
}