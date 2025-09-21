{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.m.sw.flatpak;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.sw.flatpak.enable = mkEnableOption "flatpak";

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
