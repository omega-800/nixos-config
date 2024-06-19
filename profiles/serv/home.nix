{ lib, usr, ... }:
with lib;
{
  imports = [ ];

  # pkgs
  u.dev.enable = mkDefault false;
  u.work.enable = mkDefault false;
  u.file.enable = mkDefault false;
  u.net.enable = mkDefault false;
  u.office.enable = mkDefault false;
  u.user.enable = mkDefault false;
  u.utils.enable = mkDefault false;

  # no fun only work
  u.media.enable = mkDefault false;
  u.social.enable = mkDefault false;
}
