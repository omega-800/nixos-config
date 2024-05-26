{ lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.file;
in {
  options.u.file = {
    enable = mkEnableOption "enables file packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gdu
      udiskie
      udisks
      rsync
      sshfs
      syncthing
      lf
      ctpv
      tree
      eza
      gzip
      ueberzug
      xz
    ];
  };
}
