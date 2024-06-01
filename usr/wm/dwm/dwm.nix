{ lib, config, home, pkgs, bashScriptToNix, ... }: 
let dwm_stats = bashScriptToNix "dwm_stats" ./dwm_stats.sh; in {
  home = {
    packages = with pkgs; [ st ];
    file.".xinitrc".text = ''
#setxkbmap -layout ch -variant de 
sxhkd &
xrandr
xrdb ~/.Xresources
xset -b

udiskie &
/usr/bin/dunst &
ibus-daemon -rxRd
unclutter --jitter 10 --ignore-scrolling --start-hidden --fork

#feh --bg-scale /home/omega/documents/img/wallpapers/zoro_kid.jpg
${dwm_stats} &
redshift -O3500; xset r rate 300 50; exec dwm
    '';
  };

#  services.dwm-status = {
#    enable = true;
#    order = [ "cpu_load" "network" "backlight" "audio" "battery" "time" ];
#    extraConfig = {
#      battery = {
#        notifier_levels = [ 2 5 10 15 20 25 30 ];
#      };
#    };
#  };
}
