pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.components
import qs.widgets
import qs.modules
import qs.services

// Simple singleton to set some stuff done in sway/i3

// search: querry: string;  Can search for a querry of: window title, instance, class, app_id
// swaymsg -t get_tree

// focus: pid  focus to the sway app from pid
// swaymsg '[pid="<pid>"] focus'

// kybVariant: kyb variant name (qwerty, dvorak): string 
// swaymsg input '*' xkb_variant "dvorak"

// kybLayout: kyb layout name (us, uk, fr): string
// swaymsg input "*" xkb_layout <kyb layout>

Singleton{
    id: root;

    signal searchComplete(var result);
    property bool shouldFocusAfter: false;

    function searchAndFocus(querry: string){ // Searches a querry and focuses to the first possibility
        shouldFocusAfter = true;
        search(querry);
    }

    onSearchComplete: (result) => {
        console.log(result[0].pid)
        if(shouldFocusAfter){
            root.focus(result[0].pid)
        }
        shouldFocusAfter = false;
    }

    function search(querry : string){
        getTree.running= true;

        fzf.querry= querry;
        fzf.running=true;
    }

    function focus(pid) {  
        focus.exec(["bash", "-c", `swaymsg '[pid="${pid}"] focus'`])
    }

    function kybSwitch(layout: string, variant: string){
        kybVariant.exec(["bash", "-c", `swaymsg input "*" xkb_variant ${variant}`])
        kybLayout.exec(["bash", "-c", `swaymsg input "*" xkb_layout ${layout}`])
    }

    Process{id: focus;}

    Process{id: kybLayout;}

    Process{id:kybVariant}

    Process{
        id: getTree;
        running: false;
        command: ["bash", "-c", "swaymsg -t get_tree > sw.json"];
        workingDirectory: `${Quickshell.shellDir}/fzf`;
    }

    Process{
        id: fzf;
        property var out;
        property string querry;

        running: false;
        workingDirectory: `${Quickshell.shellDir}/fzf`;
        stdinEnabled: true;
        command: ["./fzfsearch.js", querry];
        stdout: StdioCollector {
            onStreamFinished: {
                try{
                    var result = JSON.parse(this.text);
                    root.searchComplete(result);
                } catch (e){
                    console.log("fzf search failed with error: ", e);
                }
            }
        }
    }
}