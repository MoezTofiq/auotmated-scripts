#!/bin/bash

INTERNAL="eDP-1"
EXTERNAL=$(xrandr | grep " connected" | grep -v "$INTERNAL" | awk '{print $1}')

if [ -z "$EXTERNAL" ]; then
    notify-send "No external display detected" "Cannot switch to external-only mode."
    exit 1
fi

# Make external primary
xrandr --output "$EXTERNAL" --primary --auto

# Turn off internal display
xrandr --output "$INTERNAL" --off

# Move all workspaces to external
for ws in {1..10}; do
    i3-msg "workspace $ws; move workspace to output $EXTERNAL" >/dev/null
done

notify-send "External Display Mode" "Switched everything to $EXTERNAL"
