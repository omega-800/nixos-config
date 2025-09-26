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
  cfg = config.m.srv.nextcloud;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.omega.net.ip4) toStr ipFromCfg;
in
{
  options.m.srv.nextcloud.enable = mkEnableOption "nextcloud";
  config = mkIf cfg.enable {
    sops.secrets = {
      "nextcloud/rootpw" = {
        inherit (config.users.users.nextcloud) group;
        owner = config.users.users.nextcloud.name;
        mode = "0440";
      };
      "nextcloud/db" = {
        inherit (config.users.users.nextcloud) group;
        owner = config.users.users.nextcloud.name;
      };
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    services.nextcloud = {
      enable = true;
      enableImagemagick = true;
      appstoreEnable = true;
      extraApps = {
        inherit (pkgs.nextcloud31Packages.apps)
          # mail
          deck
          memories
          maps
          calendar
          contacts
          cookbook
          music
          notes
          tasks
          ;
      };
      extraAppsEnable = true;
      configureRedis = true;
      autoUpdateApps = {
        enable = false;
        startAt = "Sun 01:00:00";
      };
      caching.apcu = true;
      config = {
        adminpassFile = config.sops.secrets."nextcloud/rootpw".path;
        adminuser = usr.username;
        dbtype = "pgsql";
        # createLocally means socket auth
        # dbpassFile = config.sops.secrets."nextcloud/db".path;
        # dbhost = "localhost:50021";
      };
      database.createLocally = true;
      home = "/store/nextcloud";
      hostName = "localhost";
      # https = true;
      maxUploadSize = "1G";
      notify_push = {
        enable = false;
        bendDomainToLocalhost = true;
        logLevel = "warn";
      };
      settings = {
        # redis = {
        #   host = "/run/redis/redis.sock";
        #   port = 0;
        #   dbindex = 0;
        #   password = "secret";
        #   timeout = 1.5;
        # };
        default_phone_region = sys.region;
        "profile.enabled" = false;
        trusted_domains = [
          "nextcloud.${net.hostname}.${net.domain}"
          "${net.hostname}.${net.domain}"
          (toStr (ipFromCfg net))
        ];
      };
    };
  };
}
