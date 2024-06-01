{ bashScriptToNix, userSettings, ... }: 
let
  volumeScript = bashScriptToNix "volume_control" ./scripts/volume.sh; 
  backlightScript = bashScriptToNix "brightness_control" ./scripts/backlight.sh; 
  screenkeyScript = bashScriptToNix "toggle_screenkey" ./scripts/screenkey.sh;
  screensScript = bashScriptToNix "screens_control" ./scripts/home.sh;
in {
  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + y" = screenkeyScript;
      "super + alt + y" = "pkill -f screenkey";
      "super + shift + r" = "pkill -usr1 -x sxhkd; dunstify 'sxhkd' 'Reloaded keybindings' -t 500";
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
      "super + o ; {s,m,o,c,v,i,q,f,d,e,n,r,x,l,h,b}" = "{rofi -show drun,minecraft-launcher,obsidian,code,alacritty -e nvim,drawio,qutebrowser,firefox,discord,alacritty -e aerc,alacritty -e ncmpcpp,renoise,alacritty -e lf,libreoffice,homebank,brave}";

      # audio
      "super + a ; {j,k,l,h,p,s,r}" = "mpc {prev,next,seek + 00:00:05,seek - 00:00:05,toggle,random,repeat}";
      "{super + a ; m,XF86AudioMute}" = "${volumeScript} mute";
      "{super + a ; i,XF86AudioRaiseVolume}" = "${volumeScript} raise";
      "{super + a ; d,XF86AudioLowerVolume}" = "${volumeScript} lower";

      # system
      "super + s ; b " = "bluetooth toggle";
      "{super + s ; d,XF86MonBrightnessDown}" = "${backlightScript} lower";
      "{super + s ; i,XF86MonBrightnessUp}" = "${backlightScript} raise";
      "{super + s ; s,XF86Display}" = "${screensScript}";
      "{super + x,XF86PowerOff}" = "slock";
      # switch kb layout
      "super + s ; k ; {c,u,r}" = "setxkbmap -layout {ch -variant de,us,ru}";
    };
  };
}
