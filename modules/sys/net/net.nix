{ config, usr, lib, sys, ... }:
with lib;
let cfg = config.m.net.wifi;
in {
  options.m.net.wifi.enable = mkOption {
    description = "enables wifi";
    type = types.bool;
    default = sys.profile != "serv" && config.m.net.enable;
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
      networking = {
        hostName = sys.hostname;
        extraHosts = ''
          127.0.0.1 local.sendy.inteco.ch
        '';
        #TODO: make configurable
        domain = lib.mkDefault "home.lan";
      };
    }
  ];
}
