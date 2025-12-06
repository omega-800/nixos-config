{
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  u = {
    dev.enable = mkDefault true;
    file.enable = mkDefault true;
    net.enable = mkDefault true;
    office.enable = mkDefault true;
    utils.enable = mkDefault true;
    media.enable = mkDefault true;
    social.enable = mkDefault true;
    user = {
      enable = mkDefault true;
      nixvim.enable = mkDefault true;
    };
  };
}
