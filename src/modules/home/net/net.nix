{
  usr,
  sys,
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
        whois
      ]) ++ (optionals (sys.profile == "school") [
        wireshark
        # tshark
        termshark
        nettools
        traceroute
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
