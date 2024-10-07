{ config, sys, lib, ... }:
let
  cfg = config.m.sec.audit;
  inherit (lib) mkOption types mkIf mkMerge;
in {
  options.m.sec.audit = {
    enable = mkOption {
      description = "enables audit";
      type = types.bool;
      default = config.m.sec.enable && sys.paranoid;
    };
  };
  config = mkIf cfg.enable {
    security = {
      auditd.enable = true;
      audit = {
        enable = true;
        rules = [ "-a exit,always -F arch=b64 -S execve" ];
      };
    };
  };
}
