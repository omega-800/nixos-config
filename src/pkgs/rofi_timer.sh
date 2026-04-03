#!/usr/bin/env bash

histdir="${XDG_DATA_HOME:-$HOME/.local/share}/rofi-timer"
histfile="$histdir/histfile"

[ -d "$histdir" ] || mkdir -p "$histdir"
[ -f "$histfile" ] || : >"$histfile"

timer="$(tac "$histfile" | rofi -m -4 -dmenu -p 'Time ')"

[ "$timer" != "" ] || exit 0

grep -q -F "$timer" "$histfile" && sed -i "/$timer/d" "$histfile"
echo "$timer" >>"$histfile"

# for p in $(tr ":" "\n" <<< "$timer" | tac); do ... done

eval "sleep $timer && dunstify \"TIMER DONE ($timer)\""
