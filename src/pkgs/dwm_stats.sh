#!/usr/bin/env bash

if [ "$1" == "sand" ]; then
	nrm="^fg($2)^bg($3)"
	warning="^fg($4)^bg($5)"
	critical="^fg($6)^bg($7)"
	printf "%s" "$$" >"$XDG_RUNTIME_DIR/status_pid"
	FIFO="$XDG_RUNTIME_DIR/sandbar"
	[ -e "$FIFO" ] || mkfifo "$FIFO"
else
	nrm="\x01"
	warning="\x03"
	critical="\x04"
fi

while true; do
  # TODO: remove bloat
  netStats=($(nmcli -t -f ssid,signal,in-use dev wifi | awk -F':' '/*/ {printf "%s %s", $1, $2}'))
  netP="${netStats[2]}"
  net="${netStats[*]}%"
	nts="$( ([ "$netP" -lt "20" ] && echo "$critical") || ([ "$netP" -lt "60" ] && echo "$warning") || echo "$nrm")"

	cpu="$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf "%.f", ($2+$4-u1) * 100 / (t-t1) "%"; }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat))"
	cps="$( ([ "$cpu" -gt "80" ] && echo "$critical") || ([ "$cpu" -gt "60" ] && echo "$warning") || echo "$nrm")"

	memory="$(free | awk 'NR==2 {printf "%d", $3/$2 * 100.0}')"
	memoryStats=$(free -h --si | awk 'NR==2 {printf "%s/%s",$3,$2}')
	mms="$( ([ "$memory" -gt "80" ] && echo "$critical") || ([ "$memory" -gt "60" ] && echo "$warning") || echo "$nrm")"

  if [ "$(df | grep home | cut -d' ' -f1)" != "$(df | grep -E '/$' | cut -d' ' -f1)" ]; then
    homeD="$(df -h | awk '/home/ {printf "%d",$5}')"
    if [ "$homeD" != "" ]; then
      homeDStats="$(df -h | awk '/home/ {printf "%s/%s",$3,$2}')"
      hms="$( ([ "$homeD" -gt "80" ] && echo "$critical") || ([ "$homeD" -gt "60" ] && echo "$warning") || echo "$nrm")"
    fi
  fi

	rootD="$(df -h | awk '/\/$/ {printf "%d",$5}')"
	rootDStats="$(df -h | awk '/\/$/ {printf "%s/%s",$3,$2}')"
	rms="$( ([ "$rootD" -gt "80" ] && echo "$critical") || ([ "$rootD" -gt "60" ] && echo "$warning") || echo "$nrm")"

	time=$(date +"%H:%M")

	date=$(date +"%d-%m-%y")

  if cat /sys/class/power_supply/*0/capacity; then 
    battery=$(cat /sys/class/power_supply/*0/capacity)
    batteryStats=$(cat /sys/class/power_supply/*0/status)
    batterySymbol="$( ([ "$batteryStats" = "Discharging" ] && echo "-") || ([ "$batteryStats" = "Charging" ] && echo "+") || echo "~")"
    bts="$( ([ "$battery" -lt "30" ] && echo "$critical") || ([ "$battery" -gt "90" ] && echo "$warning") || echo "$nrm")"
  fi

  if cat /sys/class/backlight/*/actual_brightness; then 
    bla=($(cat /sys/class/backlight/*/actual_brightness))
    blm=($(cat /sys/class/backlight/*/max_brightness))
    backlight=$(("${bla[0]}" * 100 / "${blm[0]}"))
  fi

	volume=("$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/front-left:/{printf "%i", $2/2 }')" "$(pactl get-sink-mute @DEFAULT_SINK@ | sed 's/Mute: //')")
	muted="A"
	vls="$nrm"
	[ "${volume[1]}" == "off" ] || [ "${volume[1]}" == "yes" ] && muted="M" && vls="$critical"

  # TODO: refactor
	if [ "$1" == "sand" ]; then
		echo "all status $(echo -ne "${nts}[N] $net $nrm|$cps [C] $cpu% $nrm|$mms [M] $memory% ($memoryStats) $nrm|$rms [R] $rootD% ($rootDStats) $nrm$([ "$homeD" != "" ] && echo "|$hms [H] $homeD% ($homeDStats) $nrm")$([ "$backlight" != "" ] && echo "| [S] $backlight% ")|$vls [${muted}] ${volume[0]}% $nrm$([ "$battery" != "" ] && echo "|$bts [B] $batterySymbol$battery% $nrm")| $time | $date")" >"$FIFO"
	else
    xsetroot -name "$(echo -ne "${nts}[N] $net $nrm|$cps [C] $cpu% $nrm|$mms [M] $memory% ($memoryStats) $nrm|$rms [R] $rootD% ($rootDStats) $nrm$([ "$homeD" != "" ] && echo "|$hms [H] $homeD% ($homeDStats) $nrm")$([ "$backlight" != "" ] && echo "| [S] $backlight% ")|$vls [${muted}] ${volume[0]}% $nrm$([ "$battery" != "" ] && echo "|$bts [B] $batterySymbol$battery% $nrm")| $time | $date " | xargs)"
	fi
	sleep 10
done

# netStatus() {
#     cat "/sys/class/net/$1/operstate"
# }
#
# netSpeed() {
#     rx1=$(cat "/sys/class/net/$1/statistics/rx_bytes")
#     sleep 1
#     rx2=$(cat "/sys/class/net/$1/statistics/rx_bytes")
#     speed=$(numfmt --to=iec $((rx2-rx1)))
#     if [ $(echo "$speed" | grep "K" || echo "$speed" | grep "M") ]; then
#         printf "$color_on %5s/s" "$speed"
#     else
#         printf "$color_on %4sB/s" "$speed"
#     fi
# }
#
# wi="$(ls /sys/class/net/ | grep w | head -n 1)"
# ei="$(ls /sys/class/net/ | grep e | head -n 1)"
# if [ "$(getStatus "$ei")" = "up" ]; then
#     getSpeed "$ei"
# elif [ "$(getStatus "$wi")" = "up" ]; then
#     getSpeed "$wi"
# fi
