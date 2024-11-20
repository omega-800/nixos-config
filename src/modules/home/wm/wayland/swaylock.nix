{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.u.wm.wayland;
in
{
  config = mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      settings = {
        show-failed-attempts = true;
        indicator-idle-visible = false;
      };
    };
  };
}
