{
  lib,
  usr,
  config,
  ...
}:
let
  cfg = config.m.srv.acme;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.srv.acme.enable = mkEnableOption "acme";
  config = mkIf cfg.enable {
    sops.secrets = {
      "duckdns/token" = { };
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = usr.devEmail;
        webroot = "/var/lib/acme/acme-challenge/";
        enableDebugLogs = false;
        server = "https://acme-v02.api.letsencrypt.org/directory";
      };
      certs = {
        "omega-800.duckdns.org" = {
          dnsProvider = "duckdns";
          dnsPropagationCheck = true;
          #dnsResolver = "10.0.1.1:53";
          credentialFiles = {
            "DUCKDS_TOKEN_FILE" = config.sops.secrets."duckdns/token".path;
          };
          enableDebugLogs = true;
          extraDomainNames = [
            "media.omega-800.duckdns.org"
            "vpn.omega-800.duckdns.org"
          ];
        };
      };
    };

    environment.persistence = lib.mkIf config.m.fs.disko.root.impermanence.enable {
      "/nix/persist".directories = [ "/var/lib/acme" ];
    };
  };
}
