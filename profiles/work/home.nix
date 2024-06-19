{ lib, usr, ... }:
with lib;
{
  imports = [
    ../../usr/wm/${usr.wm}
    ../../usr/wm/${usr.wmType}
    ../../usr/wm/input
  ];

  # pkgs
  u = {
    dev.enable = mkDefault true;
    posix.enable = mkDefault true;
  work.enable = mkDefault true;
  file.enable = mkDefault true;
  net.enable = mkDefault true;
  office.enable = mkDefault true;
  user.enable = mkDefault true;
  utils.enable = mkDefault true;

  # no fun only work
  media.enable = mkDefault true;
  social.enable = mkDefault false;
  };
}
