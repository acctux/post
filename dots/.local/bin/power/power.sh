#!/bin/bash

# Get current profile
CURRENT=$(busctl --user get-property org.freedesktop.PowerProfiles \
  /org/freedesktop/PowerProfiles \
  org.freedesktop.PowerProfiles Profile | awk '{print $2}' | tr -d '"')

if [ "$CURRENT" = "power-saver" ]; then
    NEW="balanced"
else
    NEW="power-saver"
fi

# Set the new profile
busctl --user call org.freedesktop.PowerProfiles \
  /org/freedesktop/PowerProfiles \
  org.freedesktop.PowerProfiles SetProfile s "$NEW"

# Optional: Notify the user (if mako or other notify daemon is available)
notify-send "Power Profile" "Switched to: $NEW"
