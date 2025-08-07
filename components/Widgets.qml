pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
    // ../config/widgets.json
    // a list of widgets is available in ../widget_list.txt
    // Logic: w(widget) + l/m/f (left, middle, right) + slot number
    // There are 8 slots on one side, and 3 in the middle or with middleSplit there are two. 
    // For better examples visit the wiki (there is no wiki for now)
    property string wl1: adapter.wl1; 
    property string wl2: adapter.wl2; 
    property string wl3: adapter.wl3; 
    property string wl4: adapter.wl4; 
    property string wl5: adapter.wl5; 
    property string wl6: adapter.wl6; 
    property string wl7: adapter.wl7; 
    property string wl8: adapter.wl8; 
    property real middlePanelWidth: adapter.middlePanelWidth;


    function adapterReload(){
        fileView.reload()
    }
    function adapterOverwrite(){
        fileView.writeAdapter()
    }

    FileView{
        id: fileView;
        path: "./config/widgets.json";

        watchChanges: true;
        preload: true;
        
        onFileChanged: {
            reload();
            console.log("Widget config file changed, reloading adapter")
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
            property string wl1: ""; 
            property string wl2: ""; 
            property string wl3: ""; 
            property string wl4: ""; 
            property string wl5: ""; 
            property string wl6: ""; 
            property string wl7: ""; 
            property string wl8: ""; 
            property real middlePanelWidth: 300;            
        }
        
    }
}