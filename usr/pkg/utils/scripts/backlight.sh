#!/usr/bin/env bash

case $1 in
  "lower") brightnessctl set 5%- ;;
  "raise") brightnessctl set 5%+ ;;
  *)
    echo "Usage: $0 [lower, raise]"
    exit 1
esac

newval="$(brightnessctl i | grep Current | sed 's/.*(\(.*\)%).*/\1/')"

if (( newval < 30 ));then
  icon='sunset'
else
  icon='sun'
fi

dunstify "backlight" -h int:value:$newval -h string:x-canonical-private-synchronous:brightness -i "/usr/share/icons/feather/$icon.svg" -t 500 &

