{
  sys,
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption optionals;
  cfg = config.u.office;
in
{
  options.u.office = {
    enable = mkEnableOption "office packages";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "obsidian" ];
    home.packages =
      with pkgs;
      [
        #wtff this worked yesterday??
        #pdfslicer
        drawio
        libreoffice
        gimp
      ]
      ++ (optionals usr.extraBloat (
        [
          obsidian
          kdePackages.skanpage
          (if (usr.wmType == "x11") then gpick else hyprpicker)
        ]
        ++ (optionals (sys.profile == "pers") [
          cointop
          valentina
          homebank
        ])
      ));
  };
}
