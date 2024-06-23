{ usr, lib, config, pkgs, home, ... }: 
with lusr, ib;
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
    ] ++ (if usr.extraBloat then [
      obsidian
      skanpage
      gpick
    ] else []) ++ (if usr.extraBloat && usr.profile == "pers" then [
      cointop
      valentina
      homebank
    ] else []);
  };
}
