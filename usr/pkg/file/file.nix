{ usr, lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.file;
in {
  options.u.file = {
    enable = mkEnableOption "enables file packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rsync
    ] ++ (if !usr.minimal then [
      gzip
      unzip
      gdu
      ctpv
      tree
      eza
      ueberzug
      trash-cli
    ] else []) ++ (if usr.extraBloat then [
      xfce.thunar
      udiskie
      udisks
      sshfs
      syncthing
      xz
    ] else []);
  };
}
