{
  usr,
  inputs,
  globals,
  ...
}:
{
  imports =  [ inputs.stylix.nixosModules.stylix ];
  config =
    if !usr.style then
      { }
    else
      {
        stylix = {
          inherit (globals.styling) cursor polarity image fonts icons;
          enable = true;
          autoEnable = true;
          base16Scheme = globals.styling.colors;
          opacity.terminal = 0.85;
          targets = {
            grub = {
              enable = true;
              useWallpaper = true;
            };
            plymouth = {
              enable = true;
              logo = globals.styling.image;
              logoAnimated = true;
            };
          };
        };
      };
}
