{
  usr,
  sys,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.u.media;
  nixGL = import ../../nixGL/nixGL.nix { inherit pkgs config; };
in
{
  options.u.media = {
    enable = mkEnableOption "enables media packages";
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      (
        if !usr.minimal then
          [
            bluez
            bluez-tools
            (nixGL mpv)
          ]
        else
          [ ]
      )
      ++ (
        if usr.extraBloat then
          [
            (nixGL ani-cli)
            ffmpeg
            imagemagick
            zathura
            pavucontrol
          ]
        else
          [ ]
      );
    home.file.".profile".text = mkIf (!usr.minimal) "[ ! -s ~/.config/mpd/pid ] && mpd";
  };
}
