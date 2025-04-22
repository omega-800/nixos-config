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
  # nixGL = import ../nixGL/nixGL.nix {inherit config pkgs;};
  inherit (pkgs) nixGL;
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
            bk
          ]
        else
          [ ]
      )
      ++ (
        if usr.extraBloat then
          [
            (nixGL ani-cli)
            krita
            ffmpeg
            imagemagick
            zathura
            pavucontrol
            schismtracker
          ]
        else
          [ ]
      );
    home.file.".profile".text = mkIf (!usr.minimal) "[ ! -s ~/.config/mpd/pid ] && mpd";
  };
}
