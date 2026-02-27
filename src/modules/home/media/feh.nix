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
    # TODO: --offset +0+0
    programs.feh = {
      enable = true;
      keybindings = {
        toggle_keep_vp = "v";
        toggle_pause = "b";
        scroll_left = "h";
        scroll_right = "l";
        scroll_up = "k";
        scroll_down = "j";
        zoom_in = [
          "K"
          "Up"
        ];
        zoom_out = [
          "J"
          "Down"
        ];
      };
    };
  };
}
