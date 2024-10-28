#!/usr/bin/env bash

db="${1:-$(dirname $0)/kaomoji.txt}"
current_wid=$(xdo id)
selection=$(rofi -i -dmenu $@ < "$db")
kaomoji=$(echo $selection | sed "s|$(echo -e "\ufeff").*||")
echo -n "$kaomoji" | xclip -selection clipboard
xdotool key --window $current_wid --clearmodifiers ctrl+v

