{
  config,
  inputs,
  sys,
  usr,
  pkgs,
  net,
  globals,
  ...
}:
let
  inherit (globals.envVars) NIXOS_CONFIG;
  runScript = "${pkgs.writeScript "rofi_cmd" (builtins.readFile ../../utils/scripts/rofi-run.sh)}";
  killScript = "${pkgs.writeScript "rofi_kill" (builtins.readFile ../../utils/scripts/rofi-kill.sh)}";
  kaomojiScript = "${pkgs.writeShellScript "kaomoji" ''
    db="${../../utils/scripts/kaomoji.txt}"
    selection=$(rofi -m -4 -i -dmenu $@ < "$db")
    kaomoji=$(echo $selection | sed "s|$(echo -e "\ufeff").*||")
    echo -n "$kaomoji" | xclip -selection clipboard
  ''}";
  volumeScript = "${pkgs.writeScript "volume_control" (
    builtins.readFile ../../utils/scripts/volume.sh
  )}";
  backlightScript = "${pkgs.writeScript "brightness_control" (
    builtins.readFile ../../utils/scripts/backlight.sh
  )}";
  screensScript = "${pkgs.writeScript "screens_control" (
    builtins.readFile ../../utils/scripts/home.sh
  )}";
  sxhkdHelperScript = "${pkgs.writeScript "sxhkd_helper" (
    builtins.readFile ../../utils/scripts/sxhkd_helper.sh
  )}";
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
      "${modifier}+Ctrl h" = sxhkdHelperScript;
      # flameshot & disown solves the copy issue
      "${modifier}+Shift s" = "${if sys.genericLinux then "" else "flameshot & disown && "}flameshot gui";
      "${modifier}+Ctrl+Shift s" = "flameshot screen";
      "${modifier}+Alt+Shift s" = "flameshot full";
      # Show clipmenu
      "Alt v" = ''CM_LAUNCHER=rofi clipmenu -location 1 -m -3 -no-show-icons -theme-str "* \{ font: 10px; \}" -theme-str "listview \{ spacing: 0; \}" -theme-str "window \{ width: 20em; \}"'';
      "XF86AudioMute" = "${volumeScript} mute";
      "XF86AudioRaiseVolume" = "${volumeScript} raise";
      "XF86AudioLowerVolume" = "${volumeScript} lower";
      "XF86MonBrightnessDown" = "${backlightScript} lower";
      "XF86MonBrightnessUp" = "${backlightScript} raise";
      "XF86Display" = "${screensScript}";
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
          r = runScript;
          q = killScript;
          k = kaomojiScript;
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
          x = ''${volumeScript} mute'';
          i = ''${volumeScript} raise'';
          d = ''${volumeScript} lower'';
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

          # p = ''${rcurmon} -show p -modi p:"rofi-power-menu" -font "JetBrains Mono NF 24" -theme-str "window {width: 8em;} listview {lines: 6;}"'';
          "s d" = ''${backlightScript} lower'';
          "s i" = ''${backlightScript} raise'';
          "s r" = ''${screensScript}'';
          # "r s" = "nixos-rebuild switch --flake ${NIXOS_CONFIG}#${net.hostname}";
          # "r h" = "home-manager switch --flake ${NIXOS_CONFIG}#${net.hostname}";
        };
      };
    };
  };
}
