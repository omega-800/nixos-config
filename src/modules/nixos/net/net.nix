{
  config,
  usr,
  lib,
  sys,
  ...
}:
let
  cfg = config.m.net.wifi;
  inherit (lib)
    mkOption
    types
    mkMerge
    mkIf
    mkForce
    flatten
    mkDefault
    ;
  inherit (lib.omega.cfg) getCfgAttrOfAllHosts;
in
{
  options.m.net.wifi.enable = mkOption {
    description = "enables wifi";
    type = types.bool;
    default = sys.profile != "serv";
  };
  config = mkMerge [
    (mkIf cfg.enable {
      networking.networkmanager.enable = true;
      users.users.${usr.username}.extraGroups = [ "networkmanager" ];
    })
    (mkIf (!usr.minimal) {
      #services.opensnitch.enable = true;
      programs.mtr.enable = true;
    })
    {
      users.users.${usr.username}.openssh.authorizedKeys.keys = flatten (
        getCfgAttrOfAllHosts "sys" "pubkeys"
      );
      services.openssh.enable = true;
      programs.ssh.askPassword = mkForce "";
      networking = {
        hostName = sys.hostname;
        extraHosts = ''
          127.0.0.1 local.sendy.inteco.ch
        '';
        nameservers = [
          # Google
          "8.8.8.8"
          # Cloudflare
          "1.1.1.1"
          # DNSWatch
          "84.200.69.80"
          # Quad9
          "208.67.222.222"
        ];

        #TODO: make configurable
        domain = mkDefault "home.lan";
      };
    }
  ];
}
