#!/usr/bin/env bash

while true; do
  cpu=$(awk '{print $1}' /proc/loadavg)
  memory=$(free -h | awk 'NR==2 {print $3}')
  time=$(date +"%H:%M")
  date=$(date +"%d-%m-%y")
  battery=$(cat /sys/class/power_supply/BAT0/capacity)
  backlight=$(("$(cat /sys/class/backlight/*/actual_brightness)" * 100 / "$(cat /sys/class/backlight/*/max_brightness)"))
  volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/front-left:/{printf "%i", $2}')
  muted="A"
  [ "${volume[1]}" == "off" ] || [ "${volume[1]}" == "yes" ] && muted="M"

  stats=" [C] $cpu | [M] $memory | [S] $backlight% | [${muted}] ${volume[0]}% | [B] $battery% | $time | $date "
  xsetroot -name "$stats"
  dunstify "$stats"
  ((battery < 30)) && dunstify "LOW BATTERY"
  sleep 1m
done