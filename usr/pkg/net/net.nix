{ lib, config, pkgs, ... }: 
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
      wireguard-tools
    ] ++ (if config.c.sys.genericLinux then [] else [
      qutebrowser
    ]);
  };
}
