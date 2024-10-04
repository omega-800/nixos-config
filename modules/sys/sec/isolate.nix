{ config, sys, lib, ... }:
let
  cfg = config.m.sec.isolate;
  inherit (lib) mkOption types mkIf;
in {
  options.m.sec.isolate = {
    enable = mkOption {
      description = "enables isolate";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened;
    };
  };
  config = mkIf cfg.enable {
    #TODO: figure out what the hell this is
    security.isolate = lib.mkIf false { enable = true; };
  };
}
