#!/bin/bash

APP_NAME="MESSANGER"

# Check if notify-send is available
if command -v notify-send &> /dev/null; then
    notify-send --app-name="$APP_NAME" "DAD" "COME WASH MY BALLS" --icon=dialog-information
else
    # Fallback to direct dbus-send (with explicit app name)
    dbus-send --session --dest=org.freedesktop.Notifications \
        --type=method_call /org/freedesktop/Notifications \
        org.freedesktop.Notifications.Notify \
        string:"$APP_NAME" uint32:0 string:"dialog-information" \
        string:"Test Notification" string:"This is a test notification sent via DBus!" \
        array:string:{} dict:string:string:{} int32:5000
fi

echo "Notification sent (App: $APP_NAME)!"
