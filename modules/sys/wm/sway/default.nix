{ inputs, config, sys, lib, pkgs, usr, ... }:
let
  cfg = config.m.wm.sway;
  inherit (lib) mkOption types mkIf mkMerge;
in {
  options.m.wm.sway = {
    enable = mkOption {
      description = "enables sway";
      type = types.bool;
      default = usr.wm == "sway";
    };
  };
  config = mkIf cfg.enable { security.polkit.enable = true; };
}
