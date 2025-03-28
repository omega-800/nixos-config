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
  inherit (lib) mkEnableOption mkIf mkMerge optionals;
in
{
  options.m.sw.fonts.enable = mkEnableOption "enables fancyfonts";

  config = mkMerge [
    (mkIf cfg.enable {
      fonts = {
        fontDir.enable = true;
        fontconfig.enable = true;
        packages = optionals (! usr.minimal) (with pkgs; [ nerd-fonts.jetbrains-mono ]);
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
