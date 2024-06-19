{ lib, config, pkgs, usr, ... }: 
with lib;
let cfg = config.m.vpn.forti;
in {
  options.m.vpn.forti = {
    enable = mkEnableOption "enables openfortivpn";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.openfortivpn ];
  };
}
