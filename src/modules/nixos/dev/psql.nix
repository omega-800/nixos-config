{
  lib,
  config,
  pkgs,
  usr,
  ...
}:
let
  cfg = config.m.dev.psql;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.dev.psql.enable = mkEnableOption "psql";

  config = mkIf cfg.enable {
    services = {
      postgresql = {
        enable = true;
        package = pkgs.postgresql_15;
        ensureDatabases = [ usr.username ];
        #authentication = "local all all md5";
        #initialScript = pkgs.writeText "init-sql-script" ''
        #  alter user ${usr.username} with password 'password';
        #'';
        #ensureUsers = [
        #  {
        #    name = usr.username;
        #    ensureDBOwnership = true;
        #    ensureClauses = {
        #      superuser = true;
        #      createrole = true;
        #      createdb = true;
        #      login = true;
        #    };
        #  }
        #];
      };
    };
  };
}
