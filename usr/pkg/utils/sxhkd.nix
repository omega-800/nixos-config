{ sys, usr, lib, config, pkgs, ... }:
with lib;
let
  volumeScript = "${pkgs.writeScript "volume_control"
    (builtins.readFile ./scripts/volume.sh)}";
  kaomojiScript = "${pkgs.writeShellScript "kaomoji" ''
    db="${./scripts/kaomoji.txt}"
    selection=$(rofi -m -4 -i -dmenu $@ < "$db")
    kaomoji=$(echo $selection | sed "s|$(echo -e "\ufeff").*||")
    echo -n "$kaomoji" | xclip -selection clipboard
  ''}";
  bluetoothScript = "${pkgs.writeScript "rofi_bluetooth"
    (builtins.readFile ./scripts/rofi-bluetooth.sh)}";
  backlightScript = "${pkgs.writeScript "brightness_control"
    (builtins.readFile ./scripts/backlight.sh)}";
  screensScript = "${pkgs.writeScript "screens_control"
    (builtins.readFile ./scripts/home.sh)}";
  sxhkdHelperScript = "${pkgs.writeScript "sxhkd_helper"
    (builtins.readFile ./scripts/sxhkd_helper.sh)}";
  cfg = config.u.utils.sxhkd;
in
{
  options.u.utils.sxhkd.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable && !usr.minimal && usr.wmType == "x11";
  };

  config = mkIf cfg.enable {
    services.sxhkd = {
      enable = true;
      keybindings =
        let
          r = {
            calc = "calc -modi calc -no-show-match -no-sort";
            top = "top -modi top";
            power =
              "p -modi p:'rofi-power-menu' -font \"JetBrains Mono NF 24\" -theme-str 'window {width: 8em;} listview {lines: 6;}'";
          };
        in
        {
          "super + y" = "${pkgs.screenkey}/bin/screenkey &";
          "super + alt + y" = "pkill -f screenkey";
          "super + shift + r" = ''
            bash -c "pkill -f sxhkd; sxhkd & dunstify 'sxhkd' 'Reloaded keybindings' -t 500"'';
          "super + shift + h" = sxhkdHelperScript;
          # flameshot & disown solves the copy issue
          "super + shift + s" = "${
            if sys.genericLinux then "" else "flameshot & disown && "
          }flameshot gui";
          "super + ctrl + shift + s" = "flameshot screen";
          "super + alt + shift + s" = "flameshot full";
          "super + enter " = usr.term;

          # Show clipmenu
          "alt + v" = ''
            CM_LAUNCHER=rofi clipmenu \
                          -location 1 \
                          -m -3 \
                          -no-show-icons \
                          -theme-str "* \{ font: 10px; \}" \
                          -theme-str "listview \{ spacing: 0; \}" \
                          -theme-str "window \{ width: 20em; \}"'';

          # r for running stuffs
          # compile / flash qmk keyboard
          "super + r ; q ; {c,l,r}" = 
            "qmk {compile,flash,flash} -kb handwired/dactyl_manuform/4x6_omega -km custom {,-bl avrdude-split-left,-bl avrdude-split-right}";

          # generate password
          "super + r ; g ; p" = ''
            tr -dc "a-zA-Z0-9_#@.-" < /dev/urandom | head -c 14 | xclip -selection clipboard'';

          # clip password
          "super + r ; y" = "passmenu";
          "super + r ; r" = ''bash -c "$(rofi -dmenu -p 'Run command')"'';
          "super + r ; k" = kaomojiScript;
          "super + r ; {t,p,o,s}" =
            "rofi-{theme-selector,pass,obsidian,screenshot";
          "super + r ; {c,e,f,w}" = "rofi -m -4 -show {${r.calc},emoji,${
            if usr.extraBloat then "file-browser-extended" else "filebrowser"
          },window}";
          "super + r ; h ; {d}" = ''
            echo -e {'enable="Alt+e"\ndisable="Alt+d"\nstop="Alt+k"\nrestart="Alt+r"\ntail="Alt+t"} | rofi -m -4 -dmenu'';

          # open
          # firefox has to be opened through bash because otherwise the nixGL wrapper doesn't get applied?? /webGL doesn't work if not run through bash. don't ask why because i don't know
          "super + o ; {r,m,o,c,v,i,q,f,d,e,n,x,l,h,b}" =
            "{rofi -m -4 -show drun,minecraft-launcher,obsidian,code,${usr.term} -e nvim,drawio,qutebrowser,bash -c 'firefox',discord,${usr.term} -e aerc,${usr.term} -e ncmpcpp,${usr.term} -e lf,libreoffice,homebank,brave}";

          # audio
          "super + a ; {j,k,l,h,p,s,r}" =
            "mpc {prev,next,seek + 00:00:05,seek - 00:00:05,toggle,random,repeat}";
          "super + a ; p ; {o,i}" = "rofi-pulse-select {sink,source}";
          "super + a ; m" = "rofi-mpd";
          "{super + a ; m,XF86AudioMute}" = "${volumeScript} mute";
          "{XF86AudioRaiseVolume,super + a : i}" = "${volumeScript} raise";
          "{XF86AudioLowerVolume,super + a : d}" = "${volumeScript} lower";

          # system
          #"super + s ; b " = "bluetooth toggle";
          #"super + s ; b " = bluetoothScript;
          "super + s ; {b,v,d}" = "rofi-{bluetooth,vpn,systemd}";
          "super + s ; n" = "networkmanager_dmenu";
          "super + s ; {t,h}" = "rofi -m -4 -show {${r.top},ssh}";
          "super + s ; p" =
            "rofi -m -4 -show p -modi p:'rofi-power-menu' -font \"JetBrains Mono NF 24\" -theme-str 'window {width: 8em;} listview {lines: 6;}'";
          "{super + s ; s : d,XF86MonBrightnessDown}" =
            "${backlightScript} lower";
          "{super + s ; s : i,XF86MonBrightnessUp}" = "${backlightScript} raise";
          "{super + s ; s : r,XF86Display}" = "${screensScript}";
          "{super + x,XF86PowerOff}" = "slock";
          "super + s ; x ; h" = "xrandr --output HDMI-1 --auto --left-of eDP-1";
          # switch kb layout
          "super + s ; k ; {c,u,r}" = "setxkbmap -layout {ch -variant de,us,ru}";

          # nixOS
          "super + s ; r ; {s,h}" =
            "{nixos-rebuild,home-manager} switch --flake ${usr.homeDir}/workspace/nixos-config#${sys.hostname}";
        };
    };
  };
}
