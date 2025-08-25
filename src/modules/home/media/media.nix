{
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.u.media;
  inherit (pkgs) nixGL;
in
{
  options.u.media.enable = mkEnableOption "media packages";

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
            pavucontrol
            schismtracker
          ]
        else
          [ ]
      );
    home.file.".profile".text = mkIf (!usr.minimal) "[ ! -s ~/.config/mpd/pid ] && mpd";
    programs = mkIf usr.extraBloat {
      ncspot = {
        enable = true;
        # package = pkgs.ncspot.override { withNcurses = true; };
        settings = {
          # use_nerdfont = true;
          # notify = true;
          # repeat = "playlist";
          # TODO: format, theme
        };
      };
      zathura = {
        enable = true;
        extraConfig = "set selection-clipboard clipboard";
      };
    };
  };
}
