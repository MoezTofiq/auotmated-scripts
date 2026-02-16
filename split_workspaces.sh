#!/bin/bash

INTERNAL="eDP-1"
EXTERNAL=$(xrandr | grep " connected" | grep -v "$INTERNAL" | awk '{print $1}')

# Check if external display exists
if [ -z "$EXTERNAL" ]; then
    notify-send "No External Display" "Cannot split workspaces - no external display detected."
    exit 1
fi

# Turn on internal display if it's off and make it primary
xrandr --output "$INTERNAL" --primary --auto

# Enable external display (not mirrored)
xrandr --output "$EXTERNAL" --auto --right-of "$INTERNAL"

# Move workspaces 1-6 to internal display
for ws in {1..6}; do
    i3-msg "workspace $ws; move workspace to output $INTERNAL" >/dev/null
done

# Move workspaces 7-12 to external display
for ws in {7..12}; do
    i3-msg "workspace $ws; move workspace to output $EXTERNAL" >/dev/null
done

notify-send "Split Workspace Mode" "Workspaces 1-6 on $INTERNAL, 7-12 on $EXTERNAL"