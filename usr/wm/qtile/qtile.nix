{ ... }: {
  home.file.".xinitrc".text = ''
#doesn't work
setxkbmap -layout ch -variant de 

sxhkd &
xrandr
xrdb ~/.Xresources
xset -b

udiskie &
/usr/bin/dunst &
ibus-daemon -rxRd
unclutter --jitter 10 --ignore-scrolling --start-hidden --fork
xbindkeys -f $XDG_CONFIG_HOME/xbindkeys/config

feh --bg-scale /home/omega/documents/img/wallpapers/zoro_kid.jpg
picom & 
qtile start
  '';   
}
