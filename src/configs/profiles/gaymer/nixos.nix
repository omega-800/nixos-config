{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  m = {
    net = {
      wifi.enable = mkDefault true;
      vpn.wg.enable = mkDefault true;
    };
    hw = {
      audio = {
        enable = mkDefault true;
        pipewire = mkDefault true;
        bluetooth = mkDefault true;
      };
      io.enable = mkDefault true;
      openGL.enable = mkDefault true;
    };
    dev.tools.enable = mkDefault true;
    sw = {
      fonts.enable = mkDefault true;
      steam.enable = mkDefault true;
    };
  };
}
