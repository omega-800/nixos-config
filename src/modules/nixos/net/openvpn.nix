{
  lib,
  config,
  usr,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.m.net.vpn.openconnect;
in
{
  options.m.net.vpn.openconnect.enable = mkEnableOption "openconnect";

  config = mkIf cfg.enable {
    sops.secrets."school/vpn" = { };

    networking.openconnect = {
      interfaces = {
        school = {
          passwordFile = config.sops.secrets."school/vpn";
          gateway = "vpn.ost.ch";
          autoStart = false;
          user = usr.devEmail;
          protocol = "anyconnect";
        };
      };
    };
  };
}
