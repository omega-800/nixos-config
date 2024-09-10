{ pkgs, usr, lib, ... }:
with lib; {
  imports = [ ../../sys ];
  m = {
    power = {
      enable = mkDefault true;
      performance = mkDefault true;
    };
    dirs = {
      enable = mkDefault true;
      extraDirs = mkDefault [{ path = "/mnt/tmp"; }];
    };
  };
  services.swhkd.enable = mkDefault false; # (usr.wmType == "wayland");
}
