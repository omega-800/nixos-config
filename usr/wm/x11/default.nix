{ lib, ... }: with lib; {
  options.u.x11.initExtra = mkOption {
    type = types.str;
    default = ''
sxhkd &
xrandr
xrdb ~/.Xresources
redshift -O3500
xset -b
xset r rate 300 50
udiskie &
ibus-daemon -rxRd
unclutter --jitter 10 --ignore-scrolling --start-hidden --fork
picom &
/home/omega/.fehbg-stylix
systemctl --user import-environment DISPLAY
    '';
  };
}
