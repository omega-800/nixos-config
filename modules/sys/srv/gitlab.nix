{ usr, lib, config, ... }:
let
  cfg = config.m.srv.gitlab;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.srv.gitlab.enable = mkEnableOption "Enables gitlab";
  config = mkIf cfg.enable {
    sops.secrets = {
      "gitlab/rootpw" = { };
      "gitlab/db" = { };
      "gitlab/dbpw" = { };
      "gitlab/jws" = { };
      "gitlab/secret" = { };
    };
    services.gitlab = {
      enable = true;
      backup = {
        skip = [ "artifacts" "lfs" "tar" ];
        startAt = "03:00";
        #TODO: uploadOptions = { };
      };
      #TODO: host = "";
      https = true;
      initialRootEmail = usr.devEmail;
      initialRootPasswordFile = config.sops.secrets."gitlab/rootpw".path;
      databasePasswordFile = config.sops.secrets."gitlab/dbpw".path;
      port = 50011;
      databaseCreateLocally = true;
      registry = {
        enable = true;
        port = 50012;
        externalPort = 50013;
        #TODO: certFile = "";
        #TODO: keyFile = "";
      };
      smtp.port = 50014;
      secrets = with config.sops.secrets; {
        dbFile = "${"gitlab/db".path}";
        jwsFile = "${"gitlab/jws".path}";
        secretFile = "${"gitlab/secret".path}";
        #TODO: otpFile = "";
      };
      sidekiq = {
        #TODO: concurrency = 8;
        memoryKiller = {
          enable = true;
          graceTime = 900;
          maxMemory = 2000;
          shutdownWait = 30;
        };
      };
    };
    systemd.services.gitlab-backup.environment.BACKUP = "dump";
    #TODO: services.gitlab-runner = { };
  };
}
