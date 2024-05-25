{ lib, config, pkgs, ... }: 
with lib;
let cfg = config.m.printing;
in {
  options.m.printing = {
    enable = mkEnableOption "enables printing";
  };
 
  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
    services.avahi.openFirewall = true;
    environment.systemPackages = [ pkgs.cups-filters ];
  };
}
