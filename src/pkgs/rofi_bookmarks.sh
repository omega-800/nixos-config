#!/usr/bin/env bash

dir="${XDG_DATA_HOME:-$HOME/.local/share}/bookmarks"
file="$dir/bookmarks.txt"

[ -d "$dir" ] || mkdir -p "$dir"
[ -f "$file" ] || : >"$file"

# https://gist.github.com/Alumniminium/8fb3ab9e13eb17bc5263d433728adae3

getUrlFromBookmarkEntry() {
  bookmark="$(rofi -dmenu -p ":" <"$file")"
  [ "$bookmark" = "" ] && exit 1
  echo "$(echo "$bookmark" | cut -d '|' -f 2- | xargs)"
}

if [ $# -eq 0 ]; then
  pid="$(xdotool getactivewindow)"
  activeApp="$(xprop -id "$pid" | grep WM_CLASS | cut -d '"' -f 4)"

  if [[ "$activeApp" = "qutebrowser" || "$activeApp" = "brave" || "$activeApp" = "Chromium-browser" || "$activeApp" = "firefox" ]]; then
    xdotool activatewindow "$pid"
    sleep 0.1
    if [[ "$activeApp" = "qutebrowser" ]]; then
      xdotool key --clearmodifiers y y
    else
      xdotool key --clearmodifiers Control_L+l Control_L+a Control_L+c
    fi
    xdotool keyup Meta_L Meta_R Alt_L Alt_R Super_L Super_R # release all modifiers, otherwise they will be stuck.
  else
    dunstify "App not supported: $activeApp"
    exit 1
  fi

  bookmark="$(xclip -o -sel c | xargs)"

  [ "$bookmark" = "" ] && exit 1

  title="$(echo "$bookmark" | rofi -dmenu -p "title:")"

  [ "$title" = "" ] && exit 1

  printf "%-40s | %s\n" "$title" "$bookmark" | tee -a "$file"

elif [ "$1" = "insert" ]; then
  xdotool type "$(getUrlFromBookmarkEntry)"
elif [ "$1" = "open" ]; then
  xdg-open "$(getUrlFromBookmarkEntry)"
elif [ "$1" = "clip" ]; then
  xclip -sel c <"$(getUrlFromBookmarkEntry)"
fi
