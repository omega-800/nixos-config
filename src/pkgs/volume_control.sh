#!/usr/bin/env bash

step=5 
limit=2

curstats=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/front-left:/{printf "%i", $2}')

if [ "$1" == "raise" ] && (( 100 > $((curstats / limit)) )); then
  pactl set-sink-volume @DEFAULT_SINK@ "+${step}%"
  # amixer set Master ${step}%+ > /dev/null
elif [ "$1" == "lower" ]; then
  pactl set-sink-volume @DEFAULT_SINK@ "-${step}%"
  # amixer set Master ${step}%- > /dev/null
elif [ "$1" == "mute" ]; then
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  # amixer set Master toggle > /dev/null
else
  echo "Unrecognized parameter: ${1}"
  echo "Usage should be: volume.sh <raise|lower|mute>"
fi

stats=($(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/front-left:/{printf "%i ", $2/2 }'; pactl get-sink-mute @DEFAULT_SINK@ | sed 's/Mute: //'))
#stats=($(awk -F"[][]" '/Left:/ { printf "%i %s", $2, $4 }' <(amixer sget Master)))

#stats=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/front-left:/{printf "%i", $2/2 }')
#muted=$(pactl get-sink-mute @DEFAULT_SINK@ | sed 's/Mute: //')

muted=" "
if [ "${stats[1]}" == "off" ] || [ "${stats[1]}" == "yes" ] || (( "${stats[0]}" == 0 ));then
    icon='player-volume-muted'
    muted='muted'
elif (( ${stats[0]} < 35 ));then
    icon='go-down'
elif (( ${stats[0]} < 70 ));then
    icon='go-up'
else
    icon='player-volume'
fi

# echo ${stats[0]} ${stats[1]} $volume | xargs -l bash -c 
dunstify "volume $muted" -h "int:value:${stats[0]}" -i "$icon" -t 500
