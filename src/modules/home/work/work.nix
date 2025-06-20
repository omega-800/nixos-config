{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.u.work;
in
{
  options.u.work.enable = mkEnableOption "enables work packages";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      subversionClient
      mysql80
      postman
      # newman -> postman cli
      inkscape
      # keepass
      # veeam -> https://www.veeam.com/de/linux-backup-free.html
      slides
    ];
  };
}
