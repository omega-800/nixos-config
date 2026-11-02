{
  config,
  lib,
  pkgs,
  usr,
  ...
}:
let
  cfg = config.m.wm.kde;
  inherit (lib)
    mkOption
    types
    mkIf
    ;
in
{
  options.m.wm.kde = {
    enable = mkOption {
      description = "enables kde";
      type = types.bool;
      default = usr.wm == "kde";
    };
  };
  config = mkIf cfg.enable {

    m.wm.dm.tuigreet.enable = lib.mkForce false;
    services = {
      desktopManager.plasma6 = {
        enable = true;
        # enableQt5Integration = false;
      };
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      tlp.enable = lib.mkForce false;
    };
    environment = {
      variables.QT_QPA_PLATFORMTHEME = lib.mkForce "kde";
      plasma6.excludePackages = with pkgs.kdePackages; [
        # aurorae
        # plasma-browser-integration
        # plasma-workspace-wallpapers
        # konsole
        # kwin-x11
        # (lib.getBin qttools)
        # ark
        # elisa
        # gwenview
        # okular
        # kate
        # ktexteditor
        # khelpcenter
        # dolphin
        # baloo-widgets
        # dolphin-plugins
        # spectacle
        # ffmpegthumbs
        # krdp
      ];
    };
  };
}
