{
  usr,
  pkgs,
  config,
  ...
}:
let
  volumeScript = "${pkgs.writeScript "volume_control" (
    builtins.readFile ../../utils/scripts/volume.sh
  )}";
  runScript = "${pkgs.writeScript "rofi_cmd" (builtins.readFile ../../utils/scripts/rofi-run.sh)}";
  kaomojiScript = "${pkgs.writeShellScript "kaomoji" ''
    db="${../../utils/scripts/kaomoji.txt}"
    selection=$(rofi -m -4 -i -dmenu $@ < "$db")
    kaomoji=$(echo $selection | sed "s|$(echo -e "\ufeff").*||")
    echo -n "$kaomoji" | xclip -selection clipboard
  ''}";
  backlightScript = "${pkgs.writeScript "brightness_control" (
    builtins.readFile ../../utils/scripts/backlight.sh
  )}";
  screensScript = "${pkgs.writeScript "screens_control" (
    builtins.readFile ../../utils/scripts/home.sh
  )}";
  r = {
    calc = "calc -modi calc -no-show-match -no-sort";
    top = "top -modi top";
    power = "p -modi p:'rofi-power-menu' -font \"JetBrains Mono NF 24\" -theme-str 'window {width: 8em;} listview {lines: 6;}'";
  };
  super = config.wayland.windowManager.sway.config.modifier;
in
''
  set $mode_launcher Open: [f]irefox 
  bindsym ${super}+o mode "$mode_launcher"
  mode "$mode_launcher" {
      bindsym r exec rofi -m -4 -show drun
      bindsym m exec minecraft-launcher
      bindsym o exec obsidian
      bindsym c exec code
      bindsym v exec ${usr.term} -e nvim
      bindsym i exec drawio
      bindsym q exec qutebrowser
      bindsym f exec firefox
      bindsym d exec discord
      bindsym e exec ${usr.term} -e aerc
      bindsym n exec ${usr.term} -e ncmpcpp
      bindsym x exec ${usr.term} -e lf
      bindsym l exec libreoffice
      bindsym h exec homebank
      bindsym b exec brave

      bindsym Escape mode "default"
      bindsym Return mode "default"
  }

  set $mode_runner Run: [c]alculator
  bindsym ${super}+r mode "$mode_runner"
  mode "$mode_runner" {
      bindsym g+p exec tr -dc "a-zA-Z0-9_#@.-" < /dev/urandom | head -c 14 | xclip -selection clipboard
      bindsym y exec passmenu
      bindsym r exec ${runScript}
      bindsym q exec p="$(rofi -dmenu -p 'Kill ')" && [ -n "$p" ] && pkill -f "$p"
      bindsym k exec ${kaomojiScript}
      bindsym t exec rofi-theme-selector
      bindsym p exec rofi-pass
      bindsym o exec rofi-obsidian
      bindsym s exec rofi-screenshot
      bindsym c exec rofi -m -4 -show ${r.calc}
      bindsym e exec rofi -m -4 -show emoji
      bindsym f exec rofi -m -4 -show ${
        if usr.extraBloat then "file-browser-extended" else "filebrowser"
      }
      bindsym w exec rofi -m -4 -show window
      bindsym h+d exec echo -e {'enable="Alt+e"\ndisable="Alt+d"\nstop="Alt+k"\nrestart="Alt+r"\ntail="Alt+t"} | rofi -m -4 -dmenu      

      bindsym Escape mode "default"
      bindsym Return mode "default"
  }

  set $mode_audio Audio
  bindsym ${super}+a mode "$mode_audio"
  mode "$mode_audio" {
      bindsym j exec mpc prev
      bindsym k exec mpc next
      bindsym l exec mpc seek+00:00:05
      bindsym h exec mpc seek-00:00:05
      bindsym p exec mpc toggle
      bindsym s exec mpc random
      bindsym r exec mpc repeat
      bindsym p+o exec rofi-pulse-select sink
      bindsym p+i exec rofi-pulse-select source
      bindsym m exec rofi-mpd
      bindsym x exec ${volumeScript} mute
      bindsym i exec ${volumeScript} raise
      bindsym d exec ${volumeScript} lower

      bindsym Escape mode "default"
      bindsym Return mode "default"
  }


  set $mode_system System
  bindsym ${super}+s mode "$mode_system"
  mode "$mode_system" {
      bindsym b exec rofi-bluetooth
      bindsym v exec rofi-vpn
      bindsym d exec rofi-systemd
      bindsym n exec networkmanager_dmenu
      bindsym t exec rofi -m -4 -show ${r.top}
      bindsym h exec rofi -m -4 -show ssh
      bindsym p exec rofi -m -4 -show p -modi p:'rofi-power-menu' -font \"JetBrains Mono NF 24\" -theme-str 'window {width: 8em;} listview {lines: 6;}'
      bindsym s+d exec ${backlightScript} lower
      bindsym s+i exec ${backlightScript} raise
      bindsym s+r exec ${screensScript}
      bindsym x exec slock
      bindsym k+c exec setxkbmap -layout ch -variant de
      bindsym k+u exec setxkbmap -layout us
      bindsym k+r exec setxkbmap -layout ru

      bindsym Escape mode "default"
      bindsym Return mode "default"
  }
''
