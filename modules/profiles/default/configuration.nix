{ pkgs
, usr
, lib
, ...
}:
with lib;
{
  imports = [ ../../sys ];
  m = {
    hw.power = {
      enable = mkDefault true;
      performance = mkDefault true;
      powersave = mkDefault false;
    };
    fs.dirs = {
      enable = mkDefault true;
      extraDirs = mkDefault [{ path = "/mnt/tmp"; }];
    };
  };
}
