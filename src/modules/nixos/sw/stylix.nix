{
  lib,
  pkgs,
  inputs,
  usr,
  globals,
  ...
}:
{
  # imports =  [ inputs.stylix.nixosModules.stylix ];
  # config =
  #   if !usr.style then
  #     { }
  #   else
  #     {
  #       stylix = {
  #         inherit (globals.styling) cursor polarity image fonts;
  #         base16Scheme = globals.styling.colors;
  #         autoEnable = false;
  #         opacity.terminal = 0.85;
  #         targets = {
  #           # lightdm.enable = true;
  #           console.enable = true;
  #           # feh.enable = true;
  #           gnome.enable = false;
  #           # gtk.enable = true;
  #           # nixos-icons.enable = true;
  #           chromium.enable = false;
  #           nixvim.enable = true;
  #           grub = {
  #             enable = true;
  #             useImage = true;
  #           };
  #           # plymouth = {
  #           #   enable = true;
  #           #   logo = globals.styling.image;
  #           #   logoAnimated = true;
  #           # };
  #         };
  #       };
  #     };
}
