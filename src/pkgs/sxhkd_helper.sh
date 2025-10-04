#!/usr/bin/env bash

tmp="$(awk '/^[{a-z]/ last {print $0,"\t",last} {last=""} /^#/{last=$0}' ~/.config/sxhkd/sxhkdrc |
  column -t -s $'\t' | 
  rofi -m -4 -dmenu -i -markup-rows -no-show-icons -width 1000 -lines 15 -yoffset 40)"
echo "$tmp" | xclip -sel clip
dunstify "copied $tmp"

