{ lib, config, usr, ... }:
let
  cfg = config.m.srv.grafana;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.srv.grafana.enable = mkEnableOption "Enables grafana";
  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      #dataDir = "/srv/grafana";
      #declarativePlugins = with pkgs.grafanaPlugins; [ grafana-piechart-panel ];
      #provision = { };
      settings = {
        analytics = {
          check_for_plugin_updates = false;
          check_for_updates = false;
          feedback_links_enabled = false;
          reporting_enabled = false;
        };
        database = {
          #ca_cert_path = "";
          #client_cert_path = "";
          #client_key_path = "";
          type = "postgres";
          user = "grafana";
        };
        security = {
          admin_email = usr.devEmail;
          #admin_user = usr.devName;
          secret_key = "$__file{${"path"}}";
        };

      };
    };
  };
}
