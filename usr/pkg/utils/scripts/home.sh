#!/usr/bin/env bash

if xrandr -q | grep "HDMI1 connected" > /dev/null ; then
    xrandr --output HDMI1 --auto --left-of eDP1
else
    xrandr --output HDMI1 --off
fi

if xrandr -q | grep "DP2 connected" > /dev/null ; then
    xrandr --output HDMI1 --auto --right-of eDP1
else
    xrandr --output DP2 --off
fi
