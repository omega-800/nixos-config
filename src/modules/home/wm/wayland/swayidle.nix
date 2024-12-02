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
    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          event = "lock";
          command = "lock";
        }
      ];
      timeouts = [
        {
          timeout = 120;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 300;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
