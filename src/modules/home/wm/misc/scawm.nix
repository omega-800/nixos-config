{
  inputs,
  sys,
  usr,
  pkgs,
  ...
}:
let
  rcurmon = "rofi -m -4";
in
{
  imports = [ inputs.scawm.homeManagerModules.scawm ];
  scawm = rec {
    enable = true;
    autoEnable = true;
    modifier = "Mod4";
    bindings = {
      "${modifier}+Return" = "${usr.term}";
      "${modifier} y" = "${pkgs.screenkey}/bin/screenkey &";
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
          s = ''spotify'';
          r = ''rofi -m -4 -show drun'';
          m = ''minecraft-launcher'';
          o = ''obsidian'';
          c = ''code'';
          v = ''${usr.term} -e nvim'';
          i = ''drawio'';
          q = ''qutebrowser'';
          f = ''firefox'';
          d = ''discord'';
          e = ''${usr.term} -e aerc'';
          n = ''${usr.term} -e ncmpcpp'';
          x = ''${usr.term} -e lf'';
          l = ''libreoffice'';
          h = ''homebank'';
          b = ''brave'';
        };
      };
      "${modifier} r" = {
        name = "run";
        switch = {
          "g p" = ''tr -dc "a-zA-Z0-9_#@.-" < /dev/urandom | head -c 14 | xclip -selection clipboard'';
          y = ''passmenu'';
          r = "${pkgs.rofi_cmd}";
          q = "${pkgs.rofi_kill}";
          k = "${pkgs.kaomoji}";
          t = ''rofi-theme-selector'';
          p = ''rofi-pass'';
          o = ''rofi-obsidian'';
          s = ''rofi-screenshot'';
          c = ''${rcurmon} -show calc -modi calc -no-show-match -no-sort'';
          e = ''${rcurmon} -show emoji'';
          f = ''${rcurmon} -show ${if usr.extraBloat then "file-browser-extended" else "filebrowser"}'';
          w = ''${rcurmon} -show window'';
          # "h d" = ''echo -e {'enable="Alt+e" \ndisable="Alt+d" \nstop="Alt+k" \nrestart="Alt+r" \ntail="Alt+t"} | ${rcurmon} -dmenu'';
        };
      };
      "${modifier} m" = {
        name = "music";
        stay = {
          q = ''playerctl stop'';
          j = ''playerctl previous'';
          k = ''playerctl next'';
          l = ''playerctl position 5+'';
          h = ''playerctl position 5-'';
          p = ''playerctl play-pause'';
          t = ''playerctl loop Track'';
          a = ''playerctl loop Playlist'';
          n = ''playerctl loop None'';
          s = ''playerctl shuffle Toggle'';
          x = ''${pkgs.volume_control} mute'';
          i = ''${pkgs.volume_control} raise'';
          d = ''${pkgs.volume_control} lower'';
        };
        switch = {
          "p o" = ''rofi-pulse-select sink'';
          "p i" = ''rofi-pulse-select source'';
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
