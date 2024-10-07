{ inputs, config, sys, lib, pkgs, usr, ... }:
let
  cfg = config.m.wm.xmonad;
  inherit (lib) mkOption types mkIf mkMerge;
in {
  options.m.wm.xmonad = {
    enable = mkOption {
      description = "enables xmonad";
      type = types.bool;
      default = usr.wm == "xmonad";
    };
  };
  config = mkIf cfg.enable {
    services.xserver = {
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
      displayManager.defaultSession = "none+xmonad";
    };
  };
}
