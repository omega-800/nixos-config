{ lib, config, pkgs, ... }:
with lib;
let cfg = config.m.sw.flatpak;
in {
  options.m.sw.flatpak = {
    enable = mkOption {
      description = "enables flatpak";
      type = types.bool;
      default = config.m.sw.enable;
    };
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "gtk";
    };
  };
}
