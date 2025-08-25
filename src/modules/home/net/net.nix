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
  options.u.net.enable = mkEnableOption "net packages";

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      (optionals (!usr.minimal) [
        # (nixGL brave)
        wireguard-tools
        lsof
        tshark
        termshark
        whois
      ])
      ++ (optionals usr.extraBloat [
        (nixGL tor-browser)
        # (nixGL vieb)
      ]);
    programs.rtorrent = mkIf usr.extraBloat {
      enable = true;
    };
  };
}
