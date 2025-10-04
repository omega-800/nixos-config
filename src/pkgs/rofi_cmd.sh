#!/usr/bin/env bash

histdir="${XDG_DATA_HOME:-$HOME/.local/share}/rofi-run"
histfile="$histdir/histfile"

[ -d "$histdir" ] || mkdir -p "$histdir"
[ -f "$histfile" ] || : >"$histfile"

cmd="$(tac "$histfile" | rofi -m -4 -dmenu -p 'Run command ')"

grep -q -F "$cmd" "$histfile" && sed -i "/$cmd/d" "$histfile"
echo "$cmd" >>"$histfile"

bash -c "$cmd"
