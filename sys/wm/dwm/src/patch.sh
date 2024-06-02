#!/bin/bash

echo "patching dwm-multimon-1-monitor_marker-6.4.patch"
patch -p1 < patches/dwm-multimon-1-monitor_marker-6.4.patch
echo "patching dwm-multimon-2-unified_view-6.4.patch"
patch -p1 < patches/dwm-multimon-2-unified_view-6.4.patch
echo "patching dwm-multimon-3-reset_view-6.4.patch"
patch -p1 < patches/dwm-multimon-3-reset_view-6.4.patch
echo "patching dwm-multimon-4-status_all-6.4.patch"
patch -p1 < patches/dwm-multimon-4-status_all-6.4.patch
echo "patching dwm-multimon-5-push_up_down-6.4.patch"
patch -p1 < patches/dwm-multimon-5-push_up_down-6.4.patch
echo "patching dwm-multimon-6-swap_focus-6.4.patch"
patch -p1 < patches/dwm-multimon-6-swap_focus-6.4.patch
echo "patching dwm-multimon-7-focus_on_active-6.4.patch"
patch -p1 < patches/dwm-multimon-7-focus_on_active-6.4.patch

#echo "patching dwm-statuscolors-20220322-bece862.diff"
#patch -p1 < patches/dwm-statuscolors-20220322-bece862.diff
#echo "patching mine5.diff"
#patch -p1 < patches/mine5.diff
#echo "patching dwm-bottomstack-6.1.diff"
#patch -p1 < patches/dwm-bottomstack-6.1.diff
#echo "patching dwm-deck-6.2.diff"
#patch -p1 < patches/dwm-deck-6.2.diff
