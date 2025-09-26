{
  config,
  pkgs,
  usr,
  sys,
  net,
  lib,
  ...
}:
let
  cfg = config.m.srv.syncthing;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.omega.net.ip4) toStr ipFromCfg;
in
{
  options.m.srv.syncthing.enable = mkEnableOption "syncthing";
  config = mkIf cfg.enable {
    sops.secrets = {
      "nextcloud/rootpw" = {
        inherit (config.users.users.nextcloud) group;
        owner = config.users.users.nextcloud.name;
        mode = "0440";
      };
    };
    networking.firewall.allowedTCPPorts = [
      8384
    ];
    services.syncthing = {
      enable = true;
      dataDir = "/store/syncthing";
      openDefaultPorts = true;
      systemService = true;
      # overrideDevices = false;
      # overrideFolders = false;
      settings = {
        gui = {
          theme = "black";
        };
        options = {
          localAnnounceEnabled = false;
          minHomeDiskFree = {
            unit = "%";
            value = "2";
          };
        };
      };
      devices = {
        graphene-pers = { };
      };
      folders = { };
    };
  };
}
