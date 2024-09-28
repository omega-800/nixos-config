{ lib, config, pkgs, ... }:
with lib;
let cfg = config.m.sw.printing;
in {
  options.m.sw.printing = {
    enable = mkOption {
      description = "enables printing";
      type = types.bool;
      #CVE-2024-47176, CVE-2024-47076, CVE-2024-47175, CVE-2024-47177, etc.
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
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
