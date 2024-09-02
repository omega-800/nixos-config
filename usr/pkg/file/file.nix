{ usr, lib, config, pkgs, home, ... }:
with lib;
let cfg = config.u.file;
in {
  options.u.file = {
    enable = mkEnableOption "enables file packages";
    qol.enable = mkEnableOption "enables quality of life packages";
    bloat.enable = mkEnableOption "enables bloat";
    gui.enable = mkEnableOption "enables graphical packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [ rsync ]
      ++ (if cfg.qol.enable then [ yazi gzip unzip trash-cli gdu eza ] else [ ])
      ++ (if cfg.gui.enable then [ xfce.thunar ] else [ ])
      ++ (if cfg.bloat.enable then [
        udiskie
        udisks
        sshfs
        syncthing
        xz
      ] else
        [ ]);
  };
}
