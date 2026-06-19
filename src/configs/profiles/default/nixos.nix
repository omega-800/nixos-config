{
  lib,
  PATHS,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [ PATHS.M_NIXOS ];
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
  system.stateVersion = mkDefault "25.11";
}
