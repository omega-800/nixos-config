{
  lib,
  config,
  pkgs,
  sys,
  usr,
  ...
}:
let
  cfg = config.m.sw.fonts;
  inherit (lib) mkEnableOption mkIf mkMerge;
in
{
  options.m.sw.fonts.enable = mkEnableOption "fancyfonts";

  config = mkMerge [
    (mkIf cfg.enable {
      fonts = {
        fontDir.enable = true;
        fontconfig.enable = true;
        packages = [ usr.fontPkg ];
      };
      console = {
        inherit (sys) font;
        packages = [ sys.fontPkg ];
      };
    })
    (mkIf (!cfg.enable) {
      fonts = {
        fontDir.enable = false;
        fontconfig.enable = false;
      };
    })
  ];
}
