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
    (./. + "../../../themes" + ("/" + usr.theme) + "/backgroundsha256.txt");
in
{
  imports = if usr.style then [ inputs.stylix.nixosModules.stylix ] else [ ];
  config =
    if !usr.style then
      { }
    else {
      stylix = {
        autoEnable = true;
        polarity = themePolarity;
        opacity.terminal = 0.85;
        image = pkgs.fetchurl {
          url = backgroundUrl;
          sha256 = backgroundSha256;
        };
        base16Scheme = ./. + themePath;
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 32;
        };
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
          # feh.enable = true;
          gnome.enable = true;
          gtk.enable = true;
          nixos-icons.enable = true;
          nixvim.enable = true;
          chromium.enable = true;
          grub = {
            enable = true;
            useImage = true;
          };
          plymouth = {
            enable = true;
            logo = pkgs.fetchurl {
              url = backgroundUrl;
              sha256 = backgroundSha256;
            };
            logoAnimated = true;
          };
        };
      };
      environment.sessionVariables = { QT_QPA_PLATFORMTHEME = "qt5ct"; };
    };
}
