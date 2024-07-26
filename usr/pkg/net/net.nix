{ sys, usr, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.u.net;
  nixGL = import ../../nixGL/nixGL.nix { inherit pkgs config; };
in
{
  options.u.net = { enable = mkEnableOption "enables net packages"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      (if !usr.minimal then [
        (nixGL brave)
        (nixGL qutebrowser)
        wireguard-tools
      ] else
        [ ]) ++ (if usr.extraBloat then [
        (nixGL tor)
        (nixGL vieb)
        rtorrent

      ] else
        [ ]);
  };
}
