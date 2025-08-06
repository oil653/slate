pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
    // The widget name on posiiton w* (or the middle in wm). For widget names refer to ../widget_list.txt
    // Please only change in the ../config/widgets.json file
    // Case sensitive
    property string w1: adapter.w1; 
    property string w2: adapter.w2; 
    property string w3: adapter.w3; 
    property string w4: adapter.w4; 
    property string w5: adapter.w5; 
    property string w6: adapter.w6; 
    property string w7: adapter.w7; 
    property string w8: adapter.w8; 
    property string w9: adapter.w9; 
    property string w10: adapter.w10;
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
            property string w1: ""; 
            property string w2: ""; 
            property string w3: ""; 
            property string w4: ""; 
            property string w5: ""; 
            property string w6: ""; 
            property string w7: ""; 
            property string w8: ""; 
            property string w9: ""; 
            property string w10: "";
            property real middlePanelWidth: 300;            
        }
        
    }
}