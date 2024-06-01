{ lib, pkgs, inputs, userSettings, ... }:

let
  themePath = "../../../themes/"+userSettings.theme+"/"+userSettings.theme+".yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes"+("/"+userSettings.theme)+"/polarity.txt"));
  myLightDMTheme = if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
  backgroundUrl = builtins.readFile (./. + "../../../themes"+("/"+userSettings.theme)+"/backgroundurl.txt");
  backgroundSha256 = builtins.readFile (./. + "../../../themes/"+("/"+userSettings.theme)+"/backgroundsha256.txt");
in
  {
    imports = [ inputs.stylix.nixosModules.stylix ];
    stylix = {
      autoEnable = true;
      polarity = themePolarity;
      image = pkgs.fetchurl {
        url = backgroundUrl;
        sha256 = backgroundSha256;
      };
      base16Scheme = ./. + themePath;
      fonts = {
        monospace = {
          name = userSettings.font;
          package = userSettings.fontPkg;
        };
        serif = {
          name = userSettings.font;
          package = userSettings.fontPkg;
        };
        sansSerif = {
          name = userSettings.font;
          package = userSettings.fontPkg;
        };
        emoji = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-emoji-blob-bin;
        };
      };
      targets = {
        lightdm.enable = true;
        console.enable = true;
        chromium.enable = true;
        grub = {
          enable = true;
          useImage = true;
        };
      };
    };
#    services.xserver.displayManager.lightdm = {
#      greeters.slick.enable = true;
#      greeters.slick.theme.name = myLightDMTheme;
#    };
    environment.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  }
