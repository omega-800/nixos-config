{ usr, lib, config, pkgs, ... }:
with lib;
let cfg = config.u.user;
in {
  options.u.user = {
    enable = mkEnableOption "enables userspace packages";
    qol.enable = mkEnableOption "enables quality of life packages";
    bloat.enable = mkEnableOption "enables bloat";
    gui.enable = mkEnableOption "enables graphical packages";
  };

  config = mkIf cfg.enable {
    services.gnome-keyring = {
      enable = true;
      components = [ "ssh" "secrets" ];
    };
    home.packages = with pkgs;
      [
        #starship
        pass
      ] ++ (if cfg.qol.enable then [ tree-sitter ] else [ ])
      ++ (if cfg.gui.enable then [
        feh
        prismlauncher

        #slic3r
        # needs to be updated, build is failing
        #cura
      ] else
        [ ]) ++ (if cfg.bloat.enable then [ fortune cowsay lolcat ] else [ ]);
  };
}
