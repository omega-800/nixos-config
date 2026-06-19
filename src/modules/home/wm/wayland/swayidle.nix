{
  config,
  pkgs,
  lib,
  sys,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.u.wm.wayland;
in
{
  config = mkIf (cfg.enable && (!sys.stationary)) {
    services.swayidle = {
      enable = true;
      events = {
        before-sleep = "${pkgs.swaylock}/bin/swaylock -fF";
        lock = "lock";
      };
      timeouts = [
        {
          timeout = 240;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 360;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
