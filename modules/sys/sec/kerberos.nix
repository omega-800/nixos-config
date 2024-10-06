{ config, sys, lib, ... }:
let
  cfg = config.m.sec.kerberos;
  inherit (lib) mkOption types mkIf mkMerge;
in {
  options.m.sec.kerberos = {
    enable = mkOption {
      description = "enables kerberos";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened;
    };
  };
  config = mkIf cfg.enable {
    #TODO: research
    security.krb5 = { };
  };
}
