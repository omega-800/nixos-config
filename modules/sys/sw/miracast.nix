{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.m.sw.miracast;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.sw.miracast.enable = mkEnableOption "enables miracast";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gnome-network-displays ];

    xdg.portal = {
      enable = true;

      xdgOpenUsePortal = true;
      extraPortals = [
        #pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-wlr
      ];
    };

    networking.firewall = {
      trustedInterfaces = [ "p2p-wl+" ];

      allowedTCPPorts = [
        7236
        7250
      ];
      allowedUDPPorts = [
        7236
        5353
      ];
    };
  };
}
