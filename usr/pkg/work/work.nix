{ lib, config, pkgs, home, ... }:
with lib;
let cfg = config.u.work;
in {
  options.u.work = { enable = mkEnableOption "enables work packages"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      teamviewer
      # nable?
      # rdm -> https://devolutions.net/remote-desktop-manager/home/download/
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
      remmina # freerdp # remote-desktop
      # veeam -> https://www.veeam.com/de/linux-backup-free.html
      bottles # if i really HAVE to emulate windows
      slides
    ];
    programs.eclipse = {
      enable = true;
      package = pkgs.eclipses.eclipse-jee;
      enableLombok = true;
      jvmArgs = [ "-Xmx512m" "-ea" "-Djava.awt.headless=true" ];
      plugins = with pkgs.eclipses; [ plugins.vrapper plugins.freemarker ];
    };
  };
}
