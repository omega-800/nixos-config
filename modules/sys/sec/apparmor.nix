{ config, sys, lib, ... }:
let
  cfg = config.m.sec.apparmor;
  inherit (lib) mkOption types mkIf mkMerge;
in {
  options.m.sec.apparmor = {
    enable = mkOption {
      description = "enables apparmor";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened;
    };
  };
  config = mkIf cfg.enable {
    security.apparmor = lib.mkIf sys.hardened {
      enable = true;
      killUnconfinedConfinables = true;
      #TODO: implement? write my own? 
      # includes = { };
      # policies = { };
    };
  };
}
