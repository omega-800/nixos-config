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
        zoom_fit = "s";
        save_image = "S";
        reload_plus = "period";
        reload_minus = "comma";
        next_img = [
          "n"
          "Right"
          "space"
          "J"
        ];
        prev_img = [
          "p"
          "Left"
          "BackSpace"
          "J"
        ];
        zoom_in = [
          "Up"
          "KP_Add"
          "plus"
        ];
        zoom_out = [
          "Down"
          "KP_Subtract"
          "minus"
        ];
      };
    };
  };
}
