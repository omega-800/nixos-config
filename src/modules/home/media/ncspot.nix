{
  lib,
  config,
  pkgs,
  usr,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.media.ncspot;
in
{
  options.u.media.ncspot.enable = mkOption {
    type = types.bool;
    default = config.u.media.enable && (!usr.minimal);
  };

  config = mkIf cfg.enable {
    ncspot = {
      enable = true;
      /*
        package = pkgs.ncspot.override {
          # withNcurses = true;
          withCover = true;
          withShareSelection = true;
        };
      */
      settings = {
        use_nerdfont = true;
        notify = true;
        repeat = "playlist";
        keybindings = {
          "Ctrl+d" = "move down 15";
          "Ctrl+u" = "move up 15";
        };
        statusbar_format = "%artists - %title [%album]";
        track_format = {
          left = "%artists - %title";
          center = "[%album]";
          right = "%saved %duration";
        };
        notification_format = {
          title = "%title [%album]";
          body = "%artists";
        };
      };
    };
  };
}
