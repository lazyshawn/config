#!/usr/bin/bash

# Terminate running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar bar >>/tmp/polybar_bar.log 2>&1 &
polybar tray >>/tmp/polybar_tray.log 2>&1 &

