{ lib, config, pkgs, ... }: 
with lib;
let cfg = config.m.printing;
in {
  options.m.printing = {
    enable = mkEnableOption "enables printing";
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
