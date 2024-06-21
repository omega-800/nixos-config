{ lib, sys, usr, pkgs, ... }: 
with lib;
{
  config = mkIf sys.genericLinux {
    home.packages =
      (with pkgs; [
        brotli
        cairo
        docker
        docker-compose
        keyd
        nettools
        networkmanager
        ntfs3g
        mount
        polkit
        rsync
        timeshift
        acl
      ]) ++ (if usr.wmType == "x11" then (with pkgs.xorg; [
        xorgserver
        xset
        xrdb
        xprop
        xinit
        xauth
        xrandr
        xmodmap
        xkbcomp
        xsetroot
        setxkbmap
        encodings
        xf86videointel
      ]) else []);
  };
}
