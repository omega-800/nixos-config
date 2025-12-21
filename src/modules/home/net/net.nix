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
      [
        iproute2
        iputils
        curl
        wget
      ]
      ++ (optionals (!usr.minimal) [
        # (nixGL brave)
        wireguard-tools
        lsof
        whois
      ])
      # TODO: specialisations
      ++ (optionals (builtins.elem "school" sys.profile) [
        wireshark
        # tshark
        termshark
        nettools
        traceroute
        iperf
        nmap
        dirb
      ])
      ++ (optionals usr.extraBloat [
        (nixGL tor-browser)
        # (nixGL vieb)
      ]);
    programs.rtorrent = mkIf (!usr.minimal) {
      enable = true;
    };
  };
}
