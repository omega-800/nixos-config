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
{
  resize = {
    "h" = "resize shrink width 10 px";
    "j" = "resize grow height 10 px";
    "k" = "resize shrink height 10 px";
    "l" = "resize grow width 10 px";
    "Left" = "resize shrink width 10 px";
    "Down" = "resize grow height 10 px";
    "Up" = "resize shrink height 10 px";
    "Right" = "resize grow width 10 px";
    "Escape" = "mode default";
    "Return" = "mode default";
  };
  open = {
    r = ''mode "default", exec rofi -m -4 -show drun'';
    m = ''mode "default", exec minecraft-launcher'';
    o = ''mode "default", exec obsidian'';
    c = ''mode "default", exec code'';
    v = ''mode "default", exec ${usr.term} -e nvim'';
    i = ''mode "default", exec drawio'';
    q = ''mode "default", exec qutebrowser'';
    f = ''mode "default", exec firefox'';
    d = ''mode "default", exec discord'';
    e = ''mode "default", exec ${usr.term} -e aerc'';
    n = ''mode "default", exec ${usr.term} -e ncmpcpp'';
    x = ''mode "default", exec ${usr.term} -e lf'';
    l = ''mode "default", exec libreoffice'';
    h = ''mode "default", exec homebank'';
    b = ''mode "default", exec brave'';
    Escape = ''mode "default"'';
    Return = ''mode "default"'';
  };
  run = {

    "g+p" = ''mode "default", exec tr -dc "a-zA-Z0-9_#@.-" < /dev/urandom | head -c 14 | xclip -selection clipboard'';
    y = ''mode "default", exec passmenu'';
    r = ''mode "default", exec ${runScript}'';
    q = ''mode "default", exec p="$(rofi -dmenu -p 'Kill ')" && [ -n "$p" ] && pkill -f "$p"'';
    k = ''mode "default", exec ${kaomojiScript}'';
    t = ''mode "default", exec rofi-theme-selector'';
    p = ''mode "default", exec rofi-pass'';
    o = ''mode "default", exec rofi-obsidian'';
    s = ''mode "default", exec rofi-screenshot'';
    c = ''mode "default", exec rofi -m -4 -show ${r.calc}'';
    e = ''mode "default", exec rofi -m -4 -show emoji'';
    f = ''mode "default", exec rofi -m -4 -show ${
      if usr.extraBloat then "file-browser-extended" else "filebrowser"
    }'';
    w = ''mode "default", exec rofi -m -4 -show window'';
    "h+d" = ''mode "default", exec echo -e {'enable="Alt+e"\ndisable="Alt+d"\nstop="Alt+k"\nrestart="Alt+r"\ntail="Alt+t"} | rofi -m -4 -dmenu'';
    Escape = ''mode "default"'';
    Return = ''mode "default"'';
  };
  music = {
    j = ''exec mpc prev'';
    k = ''exec mpc next'';
    l = ''exec mpc seek+00:00:05'';
    h = ''exec mpc seek-00:00:05'';
    p = ''exec mpc toggle'';
    s = ''exec mpc random'';
    r = ''exec mpc repeat'';
    x = ''exec ${volumeScript} mute'';
    i = ''exec ${volumeScript} raise'';
    d = ''exec ${volumeScript} lower'';
    "p+o" = ''mode "default", exec rofi-pulse-select sink'';
    "p+i" = ''mode "default", exec rofi-pulse-select source'';
    m = ''mode "default", exec rofi-mpd'';
    Escape = ''mode "default"'';
    Return = ''mode "default"'';
  };
  system = {
    b = ''mode "default", exec rofi-bluetooth'';
    v = ''mode "default", exec rofi-vpn'';
    d = ''mode "default", exec rofi-systemd'';
    n = ''mode "default", exec networkmanager_dmenu'';
    t = ''mode "default", exec rofi -m -4 -show ${r.top}'';
    h = ''mode "default", exec rofi -m -4 -show ssh'';
    p = ''mode "default", exec rofi -m -4 -show p -modi p:'rofi-power-menu' -font \"JetBrains Mono NF 24\" -theme-str 'window {width: 8em;} listview {lines: 6;}'';
    "s+d" = ''mode "default", exec ${backlightScript} lower'';
    "s+i" = ''mode "default", exec ${backlightScript} raise'';
    "s+r" = ''mode "default", exec ${screensScript}'';
    "k+c" = ''mode "default", exec setxkbmap -layout ch -variant de'';
    "k+u" = ''mode "default", exec setxkbmap -layout us'';
    "k+r" = ''mode "default", exec setxkbmap -layout ru'';
    Escape = ''mode "default"'';
    Return = ''mode "default"'';
  };
}
