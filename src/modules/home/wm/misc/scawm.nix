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
    integrations.sxhkd.bindings = {
      "${modifier}+Shift r" = ''pkill -usr1 -x sxhkd; notify-send 'sxhkd' 'Reloaded config' -t 500'';
      "${modifier} + x" = "slock";
      "XF86PowerOff" = "slock";
      "${modifier} + s ; x ; h" = "xrandr --output HDMI-1 --auto --left-of eDP-1";
      "${modifier} + s ; k ; {c,u,r}" = "setxkbmap -layout {ch -variant de,us,ru}";
    };
    bindings = {
      "${modifier}+Return" = "${usr.term}";
      "${modifier}+Alt y" = "pkill -f screenkey";
      "${modifier}+Ctrl h" = sxhkdHelperScript;
      # flameshot & disown solves the copy issue
      "${modifier}+Shift s" = "${if sys.genericLinux then "" else "flameshot & disown && "}flameshot gui";
      "${modifier}+Ctrl+Shift s" = "flameshot screen";
      "${modifier}+Alt+Shift s" = "flameshot full";
      # Show clipmenu
      "Alt v" =
        ''CM_LAUNCHER=rofi clipmenu -location 1 -m -3 -no-show-icons -theme-str "* \{ font: 10px; \}" -theme-str "listview \{ spacing: 0; \}" -theme-str "window \{ width: 20em; \}"'';
      "XF86AudioMute" = "${volumeScript} mute";
      "XF86AudioRaiseVolume" = "${volumeScript} raise";
      "XF86AudioLowerVolume" = "${volumeScript} lower";
      "XF86MonBrightnessDown" = "${backlightScript} lower";
      "XF86MonBrightnessUp" = "${backlightScript} raise";
      "XF86Display" = "${screensScript}";
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
          y = ''zathura''; # actuall z
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
          k = kaomojiScript;
          o = ''rofi-obsidian'';
          p = ''rofi-pass'';
          q = killScript;
          r = runScript;
          s = ''rofi-screenshot'';
          t = ''rofi-theme-selector'';
          w = ''${rcurmon} -show window'';
          y = ''passmenu'';
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
