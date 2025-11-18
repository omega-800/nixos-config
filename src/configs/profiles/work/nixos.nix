{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  m = {
    net = {
      wifi.enable = mkDefault true;
      vpn = {
        forti.enable = mkDefault true;
        wg.enable = mkDefault true;
        mullvad.enable = mkDefault false;
      };
    };
    fs = {
      dirs.enable = true;
      automount.enable = mkDefault true;
    };
    hw = {
      audio = {
        enable = mkDefault true;
        pipewire = mkDefault true;
        bluetooth = mkDefault true;
      };
      io = {
        enable = mkDefault true;
        touchpad.enable = mkDefault true;
        tablet.enable = mkDefault true;
      };
      openGL.enable = mkDefault true;
      kernel.zen = mkDefault true;
      power = {
        enable = mkDefault true;
        performance = mkDefault true;
        powersave = mkDefault false;
      };
    };
    dev = {
      docker.enable = mkDefault true;
      virt.enable = mkDefault true;
      tools.enable = mkDefault true;
    };
    sw = {
      printing.enable = mkDefault true;
      flatpak.enable = mkDefault true;
      fonts.enable = mkDefault true;
      miracast.enable = mkDefault true;
      android.enable = mkDefault true;
    };
  };
}
