{ lib, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.static-web-server = {
    enable = true;
    root = "/srv/www";
    listen = "[::]:443";
    configuration = {
      general = {
        http2 = true;
        http2-tls-cert = "/var/lib/acme/omega-800.duckdns.org/fullchain.pem";
        http2-tls-key = "/var/lib/acme/omega-800.duckdns.org/key.pem";
        security-headers = true;
      };
    };
  };
  users.groups.www-data = { };
  systemd.services.static-web-server.serviceConfig = {
    SupplementaryGroups = lib.mkForce [
      ""
      "www-data"
    ];
    BindReadOnlyPaths = lib.mkForce [
      "/srv/www"
      "/var/lib/acme/omega-800.duckdns.org"
    ];
  };
}
