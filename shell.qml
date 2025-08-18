// @ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma UseQApplication
import QtQuick
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.modules
import qs.services


// Hello there
// You are free to use this just credit me

ShellRoot{
    id: root;
    property bool configDebug: false; // if set to true the config will always be overwritten if the qs is loaded or reloaded
    Bar{}
    NotifPopup{}

    Component.onCompleted: {
        if (root.configDebug) {
            console.log("configDebug enabled. Overwriting configs")
            Config.adapterOverwrite();
            // Widgets.adapterOverwrite();
            // Colors.adapterOverwrite();
        }
    }
}