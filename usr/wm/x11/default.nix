{ lib, ... }: with lib; {
  options.u.x11.initExtra = mkOption {
    type = types.str;
    default = ''
 sxhkd &
 xrandr
 xrdb ~/.Xresources
 #redshift -O3500
 xset -b
 xset r rate 300 50
 udiskie &
 ibus-daemon -rxRd
 picom &
 /home/omega/.fehbg-stylix
 systemctl --user import-environment DISPLAY
 # source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
    '';
  };
  config.services.unclutter = {
    enable = true;
    threshold = 5;
    timeout = 2;
    extraOptions = [
    "ignore-scrolling"
    "fork"
    "start-hidden"
    ];
  };
}
