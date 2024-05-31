{ lib, config, home, pkgs, ... }: {
  home = {
    packages = with pkgs; [ st ];
    file.".xinitrc".text = ''
#setxkbmap -layout ch -variant de 
xrandr
xrdb ~/.Xresources
xset -b

/usr/bin/dunst &
ibus-daemon -rxRd
unclutter --jitter 10 --ignore-scrolling --start-hidden --fork

#feh --bg-scale /home/omega/documents/img/wallpapers/zoro_kid.jpg
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
