{ lib, config, pkgs, sys, ... }:
with lib;
let cfg = config.m.sw.fonts;
in {
  options.m.sw.fonts = {
    enable = mkOption {
      description = "enables fancyfonts";
      type = types.bool;
      default = config.m.sw.enable;
    };
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs;
      (if usr.minimal then
        [ ]
      else
        [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ])
      ++ (if usr.extraBloat then [
        powerline
        inconsolata
        inconsolata-nerdfont
        iosevka
        font-awesome
        ubuntu_font_family
        terminus_font
      ] else
        [ ]);
    console = {
      font = sys.font;
      packages = [ sys.fontPkg ];
      keyMap = sys.kbLayout;
    };
    fonts.fontDir.enable = true;
  };
}
