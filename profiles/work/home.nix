{ config, pkgs, lib, systemSettings, userSettings, ... }:

{
  imports = [
    ../../usr/wm/${userSettings.wm}
  ];

  # pkgs
  u.dev.enable = true;
  u.work.enable = true;
  u.file.enable = true;
  u.net.enable = true;
  u.office.enable = true;
  u.user.enable = true;
  u.utils.enable = true;

  # no fun only work
  u.media.enable = true;
  u.social.enable = false;
}
