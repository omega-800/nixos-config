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
  r = {
    calc = "calc -modi calc -no-show-match -no-sort";
    top = "top -modi top";
    power = "p -modi p:'rofi-power-menu' -font \"JetBrains Mono NF 24\" -theme-str 'window {width: 8em;} listview {lines: 6;}'";
  };
  rcurmon = "rofi -m -4";
in
{
  imports = [ inputs.scawm.homeManagerModules.scawm ];
  scawm = rec {
    enable = true;
    autoEnable = true;
    modifier = "Super";
    bindings = {
      "${modifier}+Return" = "${usr.term}";
      # "${modifier} y" = "${pkgs.screenkey}/bin/screenkey &";
      "${modifier}+Alt y" = "pkill -f screenkey";
      "${modifier}+Shift r" = ''bash -c "pkill -f sxhkd; sxhkd & dunstify 'sxhkd' 'Reloaded keybindings' -t 500"'';
      "${modifier}+Shift h" = sxhkdHelperScript;
      # flameshot & disown solves the copy issue
      "${modifier}+Shift s" = "${if sys.genericLinux then "" else "flameshot & disown && "}flameshot gui";
      "${modifier}+Ctrl+Shift s" = "flameshot screen";
      "${modifier}+Alt+Shift s" = "flameshot full";
      # Show clipmenu
      "Alt v" = ''
        CM_LAUNCHER=rofi clipmenu \
                      -location 1 \
                      -m -3 \
                      -no-show-icons \
                      -theme-str "* \{ font: 10px; \}" \
                      -theme-str "listview \{ spacing: 0; \}" \
                      -theme-str "window \{ width: 20em; \}"'';
      "XF86AudioMute" = "${volumeScript} mute";
      "XF86AudioRaiseVolume" = "${volumeScript} raise";
      "XF86AudioLowerVolume" = "${volumeScript} lower";
      "XF86MonBrightnessDown" = "${backlightScript} lower";
      "XF86MonBrightnessUp" = "${backlightScript} raise";
      "XF86Display" = "${screensScript}";
      "${modifier} o" = {
        name = "open";
        switch = {
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
          q = ''p="$(${rcurmon} -dmenu -p 'Kill ')" && [ -n "$p" ] && pkill -f o$p"'';
          k = kaomojiScript;
          t = ''rofi-theme-selector'';
          p = ''rofi-pass'';
          o = ''rofi-obsidian'';
          s = ''rofi-screenshot'';
          c = ''${rcurmon} -show ${r.calc}'';
          e = ''${rcurmon} -show emoji'';
          f = ''${rcurmon} -show ${if usr.extraBloat then "file-browser-extended" else "filebrowser"}'';
          w = ''${rcurmon} -show window'';
          "h d" = ''echo -e {'enable="Alt+e"\ndisable="Alt+d"\nstop="Alt+k"\nrestart="Alt+r"\ntail="Alt+t"} | ${rcurmon} -dmenu'';
        };
      };
      "${modifier} m" = {
        name = "music";
        stay = {
          j = ''mpc prev'';
          k = ''mpc next'';
          l = ''mpc seek+00:00:05'';
          h = ''mpc seek-00:00:05'';
          p = ''mpc toggle'';
          s = ''mpc random'';
          r = ''mpc repeat'';
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
          t = ''${rcurmon} -show ${r.top}'';
          h = ''${rcurmon} -show ssh'';
          p = ''${rcurmon} -show p -modi p:'rofi-power-menu' -font \"JetBrains Mono NF 24\" -theme-str 'window {width: 8em;} listview {lines: 6;}'';
          "s d" = ''${backlightScript} lower'';
          "s i" = ''${backlightScript} raise'';
          "s r" = ''${screensScript}'';
          "r s" = "nixos-rebuild switch --flake ${NIXOS_CONFIG}#${net.hostname}";
          "r h" = "home-manager switch --flake ${NIXOS_CONFIG}#${net.hostname}";
        };
      };
    };
  };
}
