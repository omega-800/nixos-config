{ lib, usr, ... }:
with lib; {
  imports = [ ];
  u = {
    dev.enable = mkDefault true;
    file.enable = mkDefault true;
    net.enable = mkDefault true;
    user.enable = mkDefault true;
    utils.enable = mkDefault true;
    office.enable = false;
    work.enable = false;
    media.enable = false;
    social.enable = false;
  };
}
