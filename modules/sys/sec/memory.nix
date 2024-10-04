{ config, sys, lib, ... }:
let
  cfg = config.m.sec.memory;
  inherit (lib) mkOption types mkIf;
in {
  options.m.sec.memory = {
    enable = mkOption {
      description = "hardens memory access";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened;
    };
  };
  config = mkIf cfg.enable {
    environment = {
      memoryAllocator.provider = if (!sys.paranoid) then
        "libc"
      else if sys.stable then
        "scudo"
      else
        "graphene-hardened";
      variables =
        mkIf (sys.stable && sys.paranoid) { SCUDO_OPTIONS = "ZeroContents=1"; };
    };
    security = {
      forcePageTableIsolation = sys.paranoid;
      virtualisation.flushL1DataCache =
        if (sys.paranoid) then "always" else null;
    };
  };
}
