{ lib, pkgs, ... }: {
  options = {
    mPrint.enable = lib.mkEnableOption "enables printing";
  };
 
  config = lib.mkIf config.mPrint.enable {
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
    services.avahi.openFirewall = true;
    environment.systemPackages = [ pkgs.cups-filters ];
  };
}