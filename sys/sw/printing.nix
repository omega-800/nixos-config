{ lib, config, pkgs, ... }: 
with lib;
let cfg = config.m.sw.printing;
in {
  options.m.sw.printing = {
    enable = mkOption {
      description = "enables printing";
      type = types.bool;
      default = config.m.sw.enable;
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
