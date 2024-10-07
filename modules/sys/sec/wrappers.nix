{ config, sys, lib, ... }:
let
  cfg = config.m.sec.wrappers;
  inherit (lib) mkOption types mkIf mkMerge;
in {
  options.m.sec.wrappers = {
    enable = mkOption {
      description = "enables wrappers";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened;
    };
  };
  config = mkIf cfg.enable {
    #TODO: research
    security.wrappers = { };
  };
}
