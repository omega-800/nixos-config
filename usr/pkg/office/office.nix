{ sys, usr, lib, config, pkgs, home, ... }:
with lib;
let cfg = config.u.office;
in {
  options.u.office = { enable = mkEnableOption "enables office packages"; };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "obsidian" ];
    home.packages = with pkgs;
      [
        #wtff this worked yesterday??
        #pdfslicer
        drawio
        #wtff this worked yesterday??
        libreoffice
        gimp
      ] ++ (if usr.extraBloat then
        ([ obsidian skanpage gpick ] ++ (if sys.profile == "pers" then [
          cointop
          valentina
          homebank
        ] else
          [ ])) else [ ]);
  };
}
