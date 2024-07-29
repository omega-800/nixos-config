{ lib, pkgs, inputs, usr, ... }:

let
  themePath = "../../../themes/" + usr.theme + "/" + usr.theme + ".yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile
    (./. + "../../../themes" + ("/" + usr.theme) + "/polarity.txt"));
  myLightDMTheme =
    if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
  backgroundUrl = builtins.readFile
    (./. + "../../../themes" + ("/" + usr.theme) + "/backgroundurl.txt");
  backgroundSha256 = builtins.readFile
    (./. + "../../../themes/" + ("/" + usr.theme) + "/backgroundsha256.txt");
in
{
  imports = if usr.style then [ inputs.stylix.nixosModules.stylix ] else [ ];
  config = lib.mkIf usr.style {
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
          name = usr.font;
          package = usr.fontPkg;
        };
        serif = {
          name = usr.font;
          package = usr.fontPkg;
        };
        sansSerif = {
          name = usr.font;
          package = usr.fontPkg;
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
          useImage = false;
        };
      };
    };
    environment.sessionVariables = { QT_QPA_PLATFORMTHEME = "qt5ct"; };
  };
}
