{ lib, config, home, pkgs, userSettings, ... }: 
with lib;
let
  volumeScript = "${pkgs.writeScript "volume_control" (builtins.readFile ./scripts/volume.sh)}"; 
  backlightScript = "${pkgs.writeScript "brightness_control" (builtins.readFile ./scripts/backlight.sh)}"; 
  screensScript = "${pkgs.writeScript "screens_control" (builtins.readFile ./scripts/home.sh)}";
  sxhkdHelperScript = "${pkgs.writeScript "sxhkd_helper" (builtins.readFile ./scripts/sxhkd_helper.sh)}";
in {
  services.sxhkd = mkIf config.u.utils.enable {
    enable = true;
    keybindings = {
      "super + y" = "${pkgs.screenkey}/bin/screenkey &";
      "super + alt + y" = "pkill -f screenkey";
      "super + shift + r" = "pkill -usr1 -x sxhkd; dunstify 'sxhkd' 'Reloaded keybindings' -t 500";
      "super + shift + h" = sxhkdHelperScript;
      "super + shift + s" = "flameshot gui";
      "super + ctrl + shift + s" = "maim ${userSettings.homeDir}/documents/img/screenshots/$(date +%s).png";
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
      "super + r ; q ; {c,l,r}" = "qmk {compile,flash,flash} -kb handwired/dactyl_manuform/4x6_omega -km custom {,-bl avrdude-split-left,.bl avrdude-split-right}";

      # generate password
      "super + r ; g ; p" = ''tr -dc "a-zA-Z0-9_#@.-" < /dev/urandom | head -c 14 | xclip -selection clipboard'';

      # open
      "super + o ; {r,m,o,c,v,i,q,f,d,e,n,x,l,h,b}" = "{rofi -show drun,minecraft-launcher,obsidian,code,alacritty -e nvim,drawio,qutebrowser,firefox,discord,alacritty -e aerc,alacritty -e ncmpcpp,alacritty -e lf,libreoffice,homebank,brave}";

      # audio
      "super + a ; {j,k,l,h,p,s,r}" = "mpc {prev,next,seek + 00:00:05,seek - 00:00:05,toggle,random,repeat}";
      "{super + a ; m,XF86AudioMute}" = "${volumeScript} mute";
      "super + a ; i" = "${volumeScript} raise";
      "XF86AudioRaiseVolume" = "${volumeScript} raise";
      "super + a ; d" = "${volumeScript} lower";
      "XF86AudioLowerVolume" = "${volumeScript} lower";

      # system
      "super + s ; b " = "bluetooth toggle";
      "XF86MonBrightnessDown" = "${backlightScript} lower";
      "super + s ; d" = "${backlightScript} lower";
      "{super + s ; i,XF86MonBrightnessUp}" = "${backlightScript} raise";
      "{super + s ; s,XF86Display}" = "${screensScript}";
      "{super + x,XF86PowerOff}" = "slock";
      # switch kb layout
      "super + s ; k ; {c,u,r}" = "setxkbmap -layout {ch -variant de,us,ru}";
    };
  };
}
