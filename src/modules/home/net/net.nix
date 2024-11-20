{
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.u.net;
  inherit (pkgs) nixGL;
  inherit (lib) mkEnableOption mkIf optionals;
in
{
  options.u.net.enable = mkEnableOption "enables net packages";

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      (optionals (!usr.minimal) [
        (nixGL brave)
        wireguard-tools
        lsof
        tshark
        termshark
      ])
      ++ (optionals usr.extraBloat [
        (nixGL tor)
        (nixGL vieb)
      ]);
    programs.rtorrent = mkIf usr.extraBloat {
      enable = true;
    };
  };
}
