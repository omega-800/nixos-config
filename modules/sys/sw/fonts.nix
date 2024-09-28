{ lib, config, pkgs, sys, usr, ... }:
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

  config = mkMerge [
    (mkIf cfg.enable {
      fonts = {
        fontDir.enable = true;
        fontconfig.enable = true;
        packages = with pkgs;
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
      };
      console = {
        font = sys.font;
        packages = [ sys.fontPkg ];
        keyMap = sys.kbLayout;
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
