{
  lib,
  config,
  pkgs,
  usr,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.u.user.ghostty;
  inherit (pkgs) nixGL;
  package = nixGL pkgs.ghostty;
in
{
  options.u.user.ghostty.enable = mkOption {
    type = types.bool;
    default = config.u.user.enable && !usr.minimal && (usr.term == "ghostty");
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      inherit package;
      # huh what is this
      # installVimSyntax = true;
      settings = {
        window-decoration = false;
        keybind = [
          "ctrl+plus=increase_font_size:5"
          "ctrl+-=decrease_font_size:5"
          "ctrl+0=reset_font_size"
        ];
        # https://github.com/sahaj-b/ghostty-cursor-shaders/blob/main/cursor_warp.glsl
        custom-shader = "${./cursor_warp.glsl}";
      };
    };
  };
}
