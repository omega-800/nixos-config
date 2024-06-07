{ lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.work;
in {
  options.u.work = {
    enable = mkEnableOption "enables work packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      teamviewer
      # nable?
      # rdm -> https://devolutions.net/remote-desktop-manager/home/download/
      eclipses.eclipse-sdk
      subversionClient
      msgviewer # outlook
      # teams-for-linux -> doesn't work
      mysql80
      # mysql-workbench -> doesn't work
      postman
      # newman -> postman cli
      inkscape
      google-chrome
      keepass
      freerdp # remote-desktop
      # veeam -> https://www.veeam.com/de/linux-backup-free.html
      bottles # if i really HAVE to emulate windows
    ];
  };
}
