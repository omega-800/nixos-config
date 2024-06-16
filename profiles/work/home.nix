{ lib, usr, ... }:
with lib;
{
  imports = [
    ../../usr/wm/${usr.wm}
    ../../usr/wm/${usr.wmType}
  ];

  # pkgs
  u.dev.enable = mkDefault true;
  u.work.enable = mkDefault true;
  u.file.enable = mkDefault true;
  u.net.enable = mkDefault true;
  u.office.enable = mkDefault true;
  u.user.enable = mkDefault true;
  u.utils.enable = mkDefault true;

  # no fun only work
  u.media.enable = mkDefault true;
  u.social.enable = mkDefault false;
}
