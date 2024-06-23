{ sys, usr, lib, config, pkgs, ... }: 
with lib;
let 
  cfg = config.u.net;
  nixGL = import ../../nixGL/nixGL.nix { inherit pkgs config; };
in {
  options.u.net = {
    enable = mkEnableOption "enables net packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (nixGL brave)
      (nixGL qutebrowser)
    ] ++ if usr.extraBloat then [
      (nixGL tor)
      rtorrent
      wireguard-tools
    ] else [];
  };
}
