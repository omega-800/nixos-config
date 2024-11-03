{ usr, config, lib, sys, ... }:
let
  cfg = config.m.srv.nextcloud;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.srv.nextcloud.enable = mkEnableOption "Enables nextcloud";
  config = mkIf cfg.enable {
    sops.secrets = {
      "nextcloud/rootpw" = {
        mode = "0440";
        owner = config.users.users.nextcloud.name;
      };
      "nextcloud/db" = { };
    };
    services.nextcloud = {
      enable = true;
      enableImagemagick = true;
      appstoreEnable = true;
      # extraApps = { };
      # extraAppsEnable = true;
      configureRedis = true;
      autoUpdateApps = {
        enable = false;
        startAt = "Sun 01:00:00";
      };
      caching.apcu = true;
      config = {
        adminpassFile = config.sops.secrets."nextcloud/rootpw".path;
        adminuser = usr.username;
        dbpassFile = config.sops.secrets."nextcloud/db".path;
        dbtype = "pgsql";
        dbhost = "localhost:50021";
      };
      database.createLocally = true;
      # home = "/srv/nextcloud";
      # hostName = "";
      # https = true;
      maxUploadSize = "1G";
      notify_push = {
        enable = true;
        # bendDomainToLocalhost = true;
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
        # trusted_domains = [ ];
      };
    };
  };
}
