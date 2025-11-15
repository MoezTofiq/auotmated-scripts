#!/bin/bash

INTERNAL="eDP-1"
EXTERNAL=$(xrandr | grep " connected" | grep -v "$INTERNAL" | awk '{print $1}')

# Enable internal display and make it primary
xrandr --output "$INTERNAL" --primary --auto

# Move all workspaces back to internal
for ws in {1..10}; do
    i3-msg "workspace $ws; move workspace to output $INTERNAL" >/dev/null
done

# If external exists, mirror it
if [ -n "$EXTERNAL" ]; then
    xrandr --output "$EXTERNAL" --auto --same-as "$INTERNAL"
    notify-send "Mirror Mode Enabled" "External display is mirroring $INTERNAL"
else
    notify-send "Internal Display Mode" "No external display detected"
fi
