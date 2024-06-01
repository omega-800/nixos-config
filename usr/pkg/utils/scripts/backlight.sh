#!/bin/bash

# max: 24000
BRI_PATH="/sys/class/backlight/intel_backlight/brightness"

current=$(cat $BRI_PATH)
# alternatively, if xbacklight does not work:
# current=`qdbus org.gnome.SettingsDaemon.Power /org/gnome/SettingsDaemon/Power org.gnome.SettingsDaemon.Power.Screen.GetPercentage`

scale="1 2 3 4 6 8 10 13 18 25 35 50 75 100"
iter=1
case $1 in
    "lower")
        iter=14
        for val in $(tr ' ' '\n' <<< $scale | tac) ; do
            # scale = 3 to preserve some decimal values
            if (( $(bc <<< "scale=3 ; $val < $current/240/1.1") )) ; then
                newval=$val
                break
            fi
        iter=$(bc <<< "$iter-1")
        done
        ;;
    "raise")
        for val in $scale ; do
            # scale = 3 to preserve some decimal values
            echo $iter
            if (( $(bc <<< "scale=3 ; $val > $current/240*1.1") )) ; then
                newval=$val
                break
            fi
            iter=$(bc <<< "$iter+1")
        done
        ;;
    *)
        echo "Usage: $0 [up, down]"
        exit 1
esac

if [ "x$newval" == "x" ] ; then
    echo "Already at min/max."
else
    echo "Setting backlight to $newval."

    # thanks: https://bbs.archlinux.org/viewtopic.php?pid=981217#p981217
    # notify-send " " -i notification-display-brightness-low -h int:value:$newval -h string:x-canonical-private-synchronous:brightness &

    if (( newval < 30 ));then
        icon='sunset'
    else
        icon='sun'
    fi
    iter=$(bc <<< "$iter*100/14")
    echo $iter
    dunstify "backlight" -h int:value:$iter -h string:x-canonical-private-synchronous:brightness -i "/usr/share/icons/feather/$icon.svg" -t 500 &

     bc <<< "$newval * 240" > "$BRI_PATH"
#    bc <<< $newval * 240 > $BRI_PATH 
    # alternatively, if xbacklight does not work:
    # qdbus org.gnome.SettingsDaemon.Power /org/gnome/SettingsDaemon/Power org.gnome.SettingsDaemon.Power.Screen.SetPercentage $newval
fi

bash ~/scripts/dwm_stats.sh
exit 0
