{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.m.srv.keycloak;
  inherit (lib) mkEnableOption mkIf;
  realm = {
    realm = "OIDCDemo";
    enabled = true;
    clients = [
      {
        clientId = "mydemo";
        rootUrl = "http://localhost:8080";
      }
    ];
    users = [
      {
        enabled = true;
        firstName = "Christian";
        lastName = "Bauer";
        username = "cbauer";
        email = "cbauer@localhost";
        credentials = [
          {
            type = "password";
            temporary = false;
            value = "changeme";
          }
        ];
      }
    ];
  };
in
{
  options.m.srv.keycloak.enable = mkEnableOption "keycloak";
  config = mkIf cfg.enable {
    sops.secrets = {
      "keycloak/db" = { };
    };
    environment.noXlibs = false;
    services.keycloak = {
      enable = true;
      # https://wiki.nixos.org/w/index.php?title=Keycloak&mobileaction=toggle_view_mobile
      # Note: The module is not yet part of the latest NixOS stable release and will be available with version 24.11.
      # realmFiles = [ (pkgs.writeText "OIDCDemo.json" (builtins.toJSON realm)) ];
      database = {
        createLocally = true;
        #TODO: caCert = "";
        #TODO: useSSL = true;
        passwordFile = config.sops.secrets."keycloak/db".path;
        port = 50002;
        type = "postgresql";
      };
      settings = {
        hostname = "localhost";
        http-enabled = true;
        http-port = 50001;
        https-port = 50002;
        #TODO: proxy = "reencrypt";
        http-relative-path = "/cloak";
        https-key-store-file = "/path/to/file";
        https-key-store-password = {
          _secret = "/run/keys/store_password";
        };
        hostname-strict-https = false;
      };
      #TODO: sslCertificate = "";
      #TODO: sslCertificateKey = "";
    };
  };
}
