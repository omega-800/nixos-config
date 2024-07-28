{ lib, pkgs, inputs, usr, ... }:

let
  themePath = ./. + "../../../themes/${usr.theme}";
  themeYamlPath = themePath + "/${usr.theme}.yaml";
  themePolarity =
    lib.removeSuffix "\n" (builtins.readFile (themePath + "/polarity.txt"));
  themeImage =
    if builtins.pathExists (themePath + "/${usr.theme}.png") then
      themePath + "/${usr.theme}.png"
    else
      pkgs.fetchurl {
        url = builtins.readFile (themePath + "/backgroundurl.txt");
        sha256 = builtins.readFile (themePath + "/backgroundsha256.txt");
      };
  myLightDMTheme =
    if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
in
{
  imports = if usr.style then [ inputs.stylix.nixosModules.stylix ] else [ ];
  config = lib.mkIf usr.style {
    stylix = {
      autoEnable = true;
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 32;
      };
      polarity = themePolarity;
      image = themeImage;
      base16Scheme = themeYamlPath;
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
        feh.enable = true;
        gnome.enable = true;
        gtk.enable = true;
        kmscon.enable = true;
        nixos-icons.enable = true;
        nixvim.enable = true;
        plymouth = {
          enable = true;
          logoAnimated = true;
        };
        grub = {
          enable = true;
          useImage = true;
        };
      };
    };
    environment.sessionVariables = { QT_QPA_PLATFORMTHEME = "qt5ct"; };
  };
}
