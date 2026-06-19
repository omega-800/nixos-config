{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.u.net.vpn;
in
{
  options.u.net.vpn.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable;
  };
  config.home = mkIf cfg.enable {
    shellAliases = {
      vpn_work = ''netExtender -u gs2 -p "$(pass work/netextender)" -d lan.inteco.ch exchange.inteco.ch:4433 --auto-reconnect'';
    };
  };
}
