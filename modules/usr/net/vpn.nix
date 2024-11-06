{ lib, config, ... }:
with lib;
let
  cfg = config.u.net.vpn;
in
{
  options.u.net.vpn.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable;
  };
  config.home = mkIf cfg.enable {
    #file.".config/vpn/work".source = ./vpn/vpn_work;
    shellAliases = {
      #vpn_work = ''openfortivpn -c ${./vpn/vpn_work}'';
      vpn_work = ''netExtender -u gs2 -p "$(pass work/netextender)" -d lan.inteco.ch exchange.inteco.ch:4433 --auto-reconnect'';
    };
  };
}
