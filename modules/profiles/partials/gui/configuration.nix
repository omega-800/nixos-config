{ lib, ... }:
let inherit (lib) mkDefault;
in {
  imports = [ ../../sys/wm ];
  m = {
    net = { wifi.enable = mkDefault true; };
    fs = {
      enable = mkDefault true;
      dirs.enable = mkDefault true;
      automount.enable = mkDefault true;
    };
    sec = {
      enable = mkDefault true;
      firejail.enable = mkDefault true;
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
        swapCaps.enable = mkDefault true;
      };
      openGL.enable = mkDefault true;
      kernel.zen = mkDefault true;
      power = {
        enable = mkDefault true;
        performance = mkDefault true;
        powersave = mkDefault false;
      };
    };
    sw = {
      printing.enable = mkDefault true;
      flatpak.enable = mkDefault true;
      fonts.enable = mkDefault true;
      miracast.enable = mkDefault true;
    };
  };
}
