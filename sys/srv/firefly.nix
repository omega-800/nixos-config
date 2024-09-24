{ usr, config, ... }: {
  sops.secrets = {
    "firefly/appkey" = { };
    "firefly/db" = { };
  };
  services = {
    firefly-iii = {
      enable = true;
      #enableNginx = true;
      # dataDir = "/srv/firefly-iii"
      settings = {
        APP_ENV = "production";
        APP_KEY_FILE = config.sops.secrets."firefly/appkey".path;
        SITE_OWNER = usr.devEmail;
        DB_CONNECTION = "pgsql";
        DB_PORT = 50031;
        DB_DATABASE = "firefly";
        DB_USERNAME = "firefly";
        DB_PASSWORD_FILE = config.sops.secrets."firefly/db".path;
      };
    };
    firefly-iii-data-importer = {
      enable = true;
      #enableNginx = true;
      # dataDir = "/srv/firefly-iii-data-importer"
      settings = {
        APP_ENV = "local";
        LOG_CHANNEL = "syslog";
        FIREFLY_III_ACCESS_TOKEN = config.sops.secrets."firefly/appkey".path;
      };
    };
  };
}
