{ lib, pkgs, config, ... }:
with lib;
let cfg = config.m.sw.miracast;
in {
  options.m.sw.miracast.enable = mkOption {
    description = "enables miracast";
    type = types.bool;
    default = config.m.sw.enable;
  };

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

      allowedTCPPorts = [ 7236 7250 ];
      allowedUDPPorts = [ 7236 5353 ];
    };
  };
}
