pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
    // ../config/widgets.json
    property var leftWidgetList: [];
    property var middleWidgetList: [];
    property var rightWidgetList: [];
    
    Component.onCompleted: {
        refresh();
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
        path: "./config/widgets.json";

        watchChanges: true;
        preload: true;
        
        onFileChanged: {
            reload();
            refresh();
            console.log("Widget config file changed, reloading adapter");
        }
        onAdapterUpdated: {
            writeAdapter();
            console.log("Widget config adapter updated, writing adapter to file");
        }

         // If file is empty it writes the defaults  
        onLoaded: {
            if (data().length === 0 || text().trim() === "" || text().trim() === "{}") {  
                console.log("Widget config file is empty, writing defaults");  
                writeAdapter();  
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
            property var middleWidgetList: ["workspace"];
            property var rightWidgetList: ["clock"];
        }
        
    }
}