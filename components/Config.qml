pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
    property real height: adapter.height; // Panel height
    property real margin: adapter.margin // Panel margin from the side of the screens  
    property string bgColor: adapter.bgColor; // Main background color
    property real opacity: adapter.opacity; // Opacity of the bar
    property real radius: adapter.radius; // Radius of the main bar
    property bool bottomRadius: adapter.bottomRadius; // If set to true the bottom sides will have radius applyed


    function adapterReload(){
        fileView.reload()
    }
    function adapterOverwrite(){
        fileView.writeAdapter()
    }

    FileView{
        id: fileView;
        path: "./config/config.json";

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
            property string bgColor: "#3f3b3b";
            property real margin: 30;
            property real opacity: 0.6;
            property real radius: 15;
            property bool bottomRadius: true; // for dev;
        }
        
    }
}