#!/usr/bin/env bash

nrm="\x01"
warning="\x03"
critical="\x04"
counter=0

while true; do
	cpu="$(grep 'cpu ' /proc/stat | awk '{printf "%i", 100-($5*100)/($2+$3+$4+$5+$6+$7+$8+$9+$10)}')"
	cps="$( ([ "$cpu" -gt "80" ] && echo "$critical") || ([ "$cpu" -gt "60" ] && echo "$warning") || echo "$nrm")"
	memory="$(free | awk 'NR==2 {printf "%d", $3/$2 * 100.0}')"
	memoryStats=$(free -h | awk 'NR==2 {printf "%s / %s",$3,$2}')
	mms="$( ([ "$memory" -gt "80" ] && echo "$critical") || ([ "$memory" -gt "60" ] && echo "$warning") || echo "$nrm")"
	homeD="$(df -h | grep home | awk '{printf "%d",$5}')"
	homeDStats="$(df -h | grep home | awk '{printf "%s / %s",$3,$2}')"
	hms="$( ([ "$homeD" -gt "80" ] && echo "$critical") || ([ "$homeD" -gt "60" ] && echo "$warning") || echo "$nrm")"
	rootD="$(df -h | grep "/$" | awk '{printf "%d",$5}')"
	rootDStats="$(df -h | grep "/$" | awk '{printf "%s / %s",$3,$2}')"
	rms="$( ([ "$rootD" -gt "80" ] && echo "$critical") || ([ "$rootD" -gt "60" ] && echo "$warning") || echo "$nrm")"
	time=$(date +"%H:%M")
	date=$(date +"%d-%m-%y")
	battery=$(cat /sys/class/power_supply/BAT0/capacity)
	batteryStats=$(cat /sys/class/power_supply/BAT0/status)
	batterySymbol="$( ([ "$batteryStats" = "Discharging" ] && echo "-") || ([ "$batteryStats" = "Charging" ] && echo "+") || echo "~")"
	bts="$( ([ "$battery" -lt "30" ] && echo "$critical") || ([ "$battery" -gt "90" ] && echo "$warning") || echo "$nrm")"
	backlight=$(("$(cat /sys/class/backlight/*/actual_brightness)" * 100 / "$(cat /sys/class/backlight/*/max_brightness)"))
	volume=("$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/front-left:/{printf "%i", $2/2 }')" "$(pactl get-sink-mute @DEFAULT_SINK@ | sed 's/Mute: //')")
	muted="A"
	vls="$nrm"
	[ "${volume[1]}" == "off" ] || [ "${volume[1]}" == "yes" ] && muted="M" && vls="$critical"

	xsetroot -name "$(echo -ne "$cps [C] $cpu% $nrm|$mms [M] $memory% ($memoryStats) $nrm|$rms [R] $rootD% ($rootDStats) $nrm$([ "$homeD" != "" ] && echo "|$hms [H] $homeD% ($homeDStats) $nrm")| [S] $backlight% |$vls [${muted}] ${volume[0]}% $nrm|$bts [B] $batterySymbol$battery% $nrm| $time | $date " | xargs)"

	counter=$((counter + 1))
	[[ "$counter" -gt 30 ]] && counter=0 && ((battery < 30)) && [ "$batteryStats" = "Discharging" ] && dunstify -u critical "LOW BATTERY"
	sleep 10
done
