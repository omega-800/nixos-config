{ lib, config, pkgs, usr, ... }: 
with lib;
let cfg = config.m.net.vpn.forti;
in {
  options.m.net.vpn.forti = {
    enable = mkEnableOption "enables openfortivpn";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.openfortivpn ];
  };
}
