{ lib, config, pkgs, ... }: 
with lib;
let cfg = config.m.flatpak;
in {
  options.m.flatpak = {
    enable = mkEnableOption "enables flatpak";
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
