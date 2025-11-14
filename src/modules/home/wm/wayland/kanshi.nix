{ config, lib, ... }:
let
  cfg = config.u.wm.wayland;
  inherit (lib) mkIf;
in
{
  services.kanshi = mkIf cfg.enable {
    enable = true;
    systemdTarget = "graphical-session.target";
  };
}
