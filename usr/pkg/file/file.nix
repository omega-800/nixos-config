{ usr, lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.file;
in {
  options.u.file = {
    enable = mkEnableOption "enables file packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gdu
      rsync
      ctpv
      tree
      eza
      gzip
      ueberzug
    ] ++ (if usr.extraBloat then [
      udiskie
      udisks
      sshfs
      syncthing
      xz
      trash-cli
    ] else []);
  };
}
