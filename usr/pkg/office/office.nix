{ lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.office;
in {
  options.u.office = {
    enable = mkEnableOption "enables office packages";
  };
 
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "obsidian"
    ];
    home.packages = with pkgs; [
      drawio
      libreoffice
      gimp
      gpick
      skanpage
      valentina
      obsidian
      homebank
      cointop
    ];
  };
}