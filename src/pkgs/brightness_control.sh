#!/usr/bin/env bash

case $1 in
  "lower") brightnessctl set 2%- ;;
  "raise") brightnessctl set 2%+ ;;
  *)
    echo "Usage: $0 [lower, raise]"
    exit 1
esac

newval="$(brightnessctl i | grep Current | sed 's/.*(\(.*\)%).*/\1/')"

if (( newval < 30 )); then
  icon='icon_brightness-low'
else
  icon='icon_brightness-high'
fi

dunstify "backlight" -h "int:value:$newval" -h string:x-canonical-private-synchronous:brightness -I "$icon" -t 500 &

