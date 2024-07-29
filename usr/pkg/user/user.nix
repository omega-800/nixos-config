{ usr, lib, config, pkgs, ... }:
with lib;
let cfg = config.u.user;
in {
  options.u.user = { enable = mkEnableOption "enables userspace packages"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        #starship
        pass
      ] ++ (if !usr.minimal then [ tree-sitter feh ] else [ ])
      ++ (if usr.extraBloat then [
        fortune
        cowsay
        lolcat
        #slic3r
        cura
      ] else
        [ ]);
  };
}
