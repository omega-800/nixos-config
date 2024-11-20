{
  lib,
  config,
  pkgs,
  usr,
  ...
}:
let
  cfg = config.u.media.feh;
  inherit (lib) mkOption types mkIf;
in
{
  options.u.media.feh.enable = mkOption {
    type = types.bool;
    default = config.u.media.enable && !usr.minimal;
  };

  config = mkIf cfg.enable {
    programs.feh = {
      enable = true;
      keybindings = {
        toggle_keep_vp = "v";
        zoom_in = [
          "k"
          "Up"
        ];
        zoom_out = [
          "j"
          "Down"
        ];
      };
    };
  };
}
