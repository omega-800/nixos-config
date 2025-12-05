#!/usr/bin/env bash

counter=0
while true; do
	battery=$(cat /sys/class/power_supply/*0/capacity)
	batteryStats=$(cat /sys/class/power_supply/*0/status)
	[[ "$counter" -gt 30 ]] && counter=0 && ((battery < 30)) && [ "$batteryStats" = "Discharging" ] && dunstify -u critical "LOW BATTERY"
	counter=$((counter + 1))
	sleep 10
done
