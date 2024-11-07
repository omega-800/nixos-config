{
  lib,
  PATHS,
  CONFIGS,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [ (PATHS.MODULES + /${CONFIGS.nixosConfigurations}) ];
  m = {
    hw.power = {
      enable = mkDefault true;
      performance = mkDefault true;
      powersave = mkDefault false;
    };
    fs.dirs = {
      enable = mkDefault true;
      extraDirs = mkDefault [ { path = "/mnt/tmp"; } ];
    };
  };
}
