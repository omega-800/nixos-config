{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.m.sw.printing;
  inherit (lib) mkEnableOption mkIf;
in
{
  #CVE-2024-47176, CVE-2024-47076, CVE-2024-47175, CVE-2024-47177, etc.
  options.m.sw.printing.enable = mkEnableOption "printing";

  config = mkIf cfg.enable {
    services = {
      printing.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
    environment.systemPackages = [ pkgs.cups-filters ];
  };
}
