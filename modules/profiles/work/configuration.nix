{ lib, ... }:
with lib; {
  imports = [ ../../sys/wm ];
  m = {
    net = {
      enable = true;
      ssh.enable = mkDefault true;
      sshd.enable = mkDefault true;
      wifi.enable = mkDefault true;
      firewall.enable = mkDefault true;
      vpn = {
        forti.enable = mkDefault true;
        wg.enable = mkDefault true;
        # wrong one
        openvpn.enable = mkDefault false;
        mullvad.enable = mkDefault false;
      };
    };
    fs = {
      enable = true;
      dirs.enable = true;
      automount.enable = mkDefault true;
    };
    sec = {
      enable = mkDefault true;
      clamav.enable = mkDefault false;
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
    dev = {
      enable = mkDefault true;
      docker.enable = mkDefault true;
      virt.enable = mkDefault true;
      tools.enable = mkDefault true;
      mysql.enable = mkDefault true;
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
