{
  lib,
  config,
  pkgs,
  sys,
  usr,
globals,
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
    (mkIf (false && cfg.enable && usr.style) {
      services.kmscon = {
        fonts = [
          {
            package =  usr.fontPkg;
            name = usr.font;
          }
        ];
        extraConfig = "font-size=${toString globals.styling.fonts.sizes.applications}";

        enable = true;
        useXkbConfig = true;
        hwRender = true;
        term = "xterm-256color";
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
