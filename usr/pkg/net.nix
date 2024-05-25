{ lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.net;
in {
  options.u.net = {
    enable = mkEnableOption "enables net packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rtorrent
      tor
      brave
      qutebrowser
      wireguard-tools
    ];
  };
}
