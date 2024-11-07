{
  lib,
  sys,
  usr,
  pkgs,
  genericLinuxSystemInstaller,
  config,
  ...
}:
with lib;
{
  config = mkIf sys.genericLinux {
    #   home.file."system_installer.sh" = {
    #     executable = true;
    #     text = "${genericLinuxSystemInstaller}${config.programs.bash.bashrcExtra}";
    #   };
    home.packages = mkIf usr.extraBloat (
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
        xterm
        xdg-utils
      ])
      ++ (
        if
          true # usr.wmType == "x11"
        then
          (with pkgs.xorg; [
            #xorgserver
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
          ])
        else
          [ ]
      )
    );
  };
}
