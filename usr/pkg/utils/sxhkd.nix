{ sys, usr, lib, config, pkgs, ... }: 
with lib;
let
  volumeScript = "${pkgs.writeScript "volume_control" (builtins.readFile ./scripts/volume.sh)}"; 
  backlightScript = "${pkgs.writeScript "brightness_control" (builtins.readFile ./scripts/backlight.sh)}"; 
  screensScript = "${pkgs.writeScript "screens_control" (builtins.readFile ./scripts/home.sh)}";
  sxhkdHelperScript = "${pkgs.writeScript "sxhkd_helper" (builtins.readFile ./scripts/sxhkd_helper.sh)}";
  cfg = config.u.utils;
in {
  services.sxhkd = mkIf cfg.enable {
    enable = true;
    keybindings = {
      "super + y" = "${pkgs.screenkey}/bin/screenkey &";
      "super + alt + y" = "pkill -f screenkey";
      "super + shift + r" = "pkill -usr1 -x sxhkd; dunstify 'sxhkd' 'Reloaded keybindings' -t 500";
      "super + shift + h" = sxhkdHelperScript;
      "super + shift + s" = "flameshot gui";
      "super + ctrl + shift + s" = "maim ${usr.homeDir}/documents/img/screenshots/$(date +%s).png";
      "super + enter " = "alacritty";

      # Show clipmenu
      "alt + v" = ''CM_LAUNCHER=rofi clipmenu \
              -location 1 \
              -m -3 \
              -no-show-icons \
              -theme-str "* \{ font: 10px; \}" \
              -theme-str "listview \{ spacing: 0; \}" \
              -theme-str "window \{ width: 20em; \}"'';

      # r for running stuffs
      # compile / flash qmk keyboard
      "super + r ; q ; {c,l,r}" = "qmk {compile,flash,flash} -kb handwired/dactyl_manuform/4x6_omega -km custom {,-bl avrdude-split-left,-bl avrdude-split-right}";

      # generate password
      "super + r ; g ; p" = ''tr -dc "a-zA-Z0-9_#@.-" < /dev/urandom | head -c 14 | xclip -selection clipboard'';

      # clip password
      "super + r ; rp" = ''passmenu'';

      "super + r ; t" = ''rofi-theme-selector'';
      "super + r ; p" = ''rofi-pass'';
      "super + r ; s" = ''rofi -show ssh'';

      "super + r ; {c,a,d,e,v,x,m,o,s,p,f,u,w}" = ''rofi {-show calc -modi calc -no-show-match -no-sort,,,,,-show top -modi top,,,,,-show filebrowser,,-show window}'';
      #TODO: implement these
      #rofi-calc
      #rofi-mpd
      #rofi-systemd
      #rofimoji
      #rofi-vpn
      #rofi-top
      #rofi-menugen
      #rofi-obsidian
      #rofi-screenshot
      #rofi-power-menu
      #rofi-file-browser (extended)
      #rofi-pulse-select

      # nixOS
      "super + n ; {s,h}" = ''{nixos-rebuild,home-manager} switch --flake ${usr.homeDir}/workspace/nixos-config#${sys.hostname}'';

      # open
      "super + o ; {r,m,o,c,v,i,q,f,d,e,n,x,l,h,b}" = "{rofi -show drun,minecraft-launcher,obsidian,code,alacritty -e nvim,drawio,qutebrowser,firefox,discord,alacritty -e aerc,alacritty -e ncmpcpp,alacritty -e lf,libreoffice,homebank,brave}";

      # audio
      "super + a ; {j,k,l,h,p,s,r}" = "mpc {prev,next,seek + 00:00:05,seek - 00:00:05,toggle,random,repeat}";
      "{super + a ; m,XF86AudioMute}" = "${volumeScript} mute";
      "{XF86AudioRaiseVolume,super + a : i}" = "${volumeScript} raise";
      "{XF86AudioLowerVolume,super + a : d}" = "${volumeScript} lower";

      # system
      "super + s ; b " = "bluetooth toggle";
      "{super + s ; s : d,XF86MonBrightnessDown}" = "${backlightScript} lower";
      "{super + s ; s : i,XF86MonBrightnessUp}" = "${backlightScript} raise";
      "{super + s ; s : s,XF86Display}" = "${screensScript}";
      "{super + x,XF86PowerOff}" = "slock";
      "super + s ; x ; h" = "xrandr --output HDMI-1 --auto --left-of eDP-1";
      # switch kb layout
      "super + s ; k ; {c,u,r}" = "setxkbmap -layout {ch -variant de,us,ru}";
    };
  };
}
