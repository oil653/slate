pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
    // Singleton to set colors
    // Do not modify values here but in ./config/colors.json
    // By default it follows the Catppuccin Mocha theme (though naming may differ)
    property string background: adapter.background;
    property string surface0: adapter.surface0;
    property string overlay0: adapter.overlay0;
    property string overlay1: adapter.overlay1;
    property string text: adapter.text;
    property string text1: adapter.text1;
    property string text2: adapter.text2;
    property string red: adapter.red;
    property string yellow: adapter.yellow;
    property string green: adapter.green;    


    function adapterReload(){
        fileView.reload()
    }
    function adapterOverwrite(){
        fileView.writeAdapter()
    }

    FileView{
        id: fileView;
        path: Quickshell.shellPath("config/colors.json");

        watchChanges: true;
        preload: true;
        
        onFileChanged: {
            reload();
            console.log("Colors config file changed, reloading adapter")
        }
        onAdapterUpdated: {
            writeAdapter();
            console.log("Colors config adapter updated, writing adapter to file");
        }

         // If file is empty it writes the defaults  
        onLoaded: {
            if (data().length === 0 || text().trim() === "" || text().trim() === "{}") {  
                console.log("Colors config file is empty, writing defaults");  
                writeAdapter();  
            }  
        }  
        
        // If file doesnt exists it tries to create a new one with the default parameters in it
        // Not too reliable
        onLoadFailed: function(error) {  
            if (error === FileViewError.FileNotFound) {  
                console.log("Colors config file not found, attempting to create one with defaults");  
                writeAdapter();  
            }  
        }  
        
        JsonAdapter {
            id: adapter;

            property string background: "#1e1e2e";
            property string surface0: "#313244";
            property string overlay0: "#9399b2";
            property string overlay1: "#45475a";
            property string text: "#cdd6f4";
            property string text1: "#11111b";
            property string text2: "#94e2d5";
            property string red: "#f38ba8";
            property string yellow: "#f9e2af";
            property string green: "#a6e3a1";
        }
        
    }
}