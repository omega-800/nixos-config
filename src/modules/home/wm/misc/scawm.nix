{
  inputs,
  sys,
  usr,
  pkgs,
  ...
}:
let
  rcurmon = "rofi -m -4";
  modifier = "Mod4";
in
{
  imports = [ inputs.scawm.homeManagerModules.scawm ];
  scawm = {
    enable = true;
    inherit modifier;
    autoEnable = true;
    integrations.sxhkd.bindings = {
      "${modifier}+Shift r" = ''pkill -usr1 -x sxhkd; notify-send 'sxhkd' 'Reloaded config' -t 500'';
      "${modifier} + x" = "slock";
      "XF86PowerOff" = "slock";
      "${modifier} + s ; x ; h" = "xrandr --output HDMI-1 --auto --left-of eDP-1";
      "${modifier} + s ; k ; {c,u,r}" = "setxkbmap -layout {ch -variant de,us,ru}";
    };
    bindings = {
      "${modifier} Return" = "${usr.term}";
      "${modifier}+Alt y" = "pkill -f screenkey";
      "${modifier}+Ctrl h" = "${pkgs.sxhkd_helper}";
      # flameshot & disown solves the copy issue
      "${modifier}+Shift s" = "${if sys.genericLinux then "" else "flameshot & disown && "}flameshot gui";
      "${modifier}+Ctrl+Shift s" = "flameshot screen";
      "${modifier}+Alt+Shift s" = "flameshot full";
      # Show clipmenu
      "Alt v" = ''CM_LAUNCHER=rofi clipmenu -location 1 -m -3 -no-show-icons -theme-str "* \{ font: 10px; \}" -theme-str "listview \{ spacing: 0; \}" -theme-str "window \{ width: 20em; \}"'';
      "XF86AudioMute" = "${pkgs.volume_control} mute";
      "XF86AudioRaiseVolume" = "${pkgs.volume_control} raise";
      "XF86AudioLowerVolume" = "${pkgs.volume_control} lower";
      "XF86MonBrightnessDown" = "${pkgs.brightness_control} lower";
      "XF86MonBrightnessUp" = "${pkgs.brightness_control} raise";
      "XF86Display" = "${pkgs.screens_control}";
      "${modifier} o" = {
        name = "open";
        switch = {
          b = ''${usr.browser}'';
          c = ''code'';
          d = ''discord'';
          e = ''${usr.term} -e aerc'';
          f = ''firefox'';
          h = ''homebank'';
          i = ''drawio'';
          l = ''libreoffice'';
          m = ''minecraft-launcher'';
          n = ''${usr.term} -e ncmpcpp'';
          o = ''obsidian'';
          q = ''qutebrowser'';
          r = ''rofi -m -4 -show drun'';
          s = ''spotify'';
          v = ''${usr.term} -e nvim'';
          x = ''${usr.term} -e lf'';
          y = ''zathura''; # actually z
          z = ''${pkgs.screenkey}/bin/screenkey &''; # actually y
        };
      };
      "${modifier} r" = {
        name = "run";
        switch = {
          c = ''${rcurmon} -show calc -modi calc -no-show-match -no-sort'';
          e = ''${rcurmon} -show emoji'';
          f = ''${rcurmon} -show ${if usr.extraBloat then "file-browser-extended" else "filebrowser"}'';
          "g p" = ''tr -dc "a-zA-Z0-9_#@.-" < /dev/urandom | head -c 14 | xclip -selection clipboard'';
          # "h d" = ''echo -e {'enable="Alt+e" \ndisable="Alt+d" \nstop="Alt+k" \nrestart="Alt+r" \ntail="Alt+t"} | ${rcurmon} -dmenu'';
          k = "${pkgs.kaomoji}";
          o = ''rofi-obsidian'';
          p = ''rofi-pass'';
          q = "${pkgs.rofi_kill}";
          r = "${pkgs.rofi_cmd}";
          s = ''rofi-screenshot'';
          t = ''rofi-theme-selector'';
          w = ''${rcurmon} -show window'';
          y = ''passmenu'';
        };
      };
      "${modifier} m" = {
        name = "music";
        stay = {
          a = ''playerctl loop Playlist'';
          d = ''${pkgs.volume_control} lower'';
          h = ''playerctl position 5-'';
          i = ''${pkgs.volume_control} raise'';
          j = ''playerctl previous'';
          k = ''playerctl next'';
          l = ''playerctl position 5+'';
          n = ''playerctl loop None'';
          p = ''playerctl play-pause'';
          q = ''playerctl stop'';
          s = ''playerctl shuffle Toggle'';
          t = ''playerctl loop Track'';
          x = ''${pkgs.volume_control} mute'';
        };
        switch = {
          "r o" = ''rofi-pulse-select sink'';
          "r i" = ''rofi-pulse-select source'';
          m = ''rofi-mpd'';
        };
      };
      "${modifier} s" = {
        name = "system";
        switch = {
          b = ''rofi-bluetooth'';
          v = ''rofi-vpn'';
          d = ''rofi-systemd'';
          n = ''networkmanager_dmenu'';
          t = ''${rcurmon} -show top -modi top'';
          h = ''${rcurmon} -show ssh'';

          "s d" = ''${pkgs.brightness_control} lower'';
          "s i" = ''${pkgs.brightness_control} raise'';
          "s r" = ''${pkgs.screens_control}'';
          # "r s" = "nixos-rebuild switch --flake ${NIXOS_CONFIG}#${net.hostname}";
          # "r h" = "home-manager switch --flake ${NIXOS_CONFIG}#${net.hostname}";
        };
      };
    };
  };
}
