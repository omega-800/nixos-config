{ config, sys, lib, ... }:
let
  cfg = config.m.sec.pam;
  inherit (lib) mkOption types mkIf mkMerge;
in {
  options.m.sec.pam = {
    enable = mkOption {
      description = "enables pam";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened;
    };
  };
  config = mkIf cfg.enable {
    #TODO: research and harden
    security.pam = { };
  };
}
