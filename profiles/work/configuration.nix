{ lib, ... }:
with lib; {
  imports = [ ../../sys/wm ];
  m = {
    audio = {
      enable = mkDefault true;
      pipewire = mkDefault true;
      bluetooth = mkDefault true;
    };
    automount.enable = mkDefault true;
    ssh.enable = mkDefault true;
    kernel.zen = mkDefault true;
    openGL.enable = mkDefault true;
    printing.enable = mkDefault true;
    docker.enable = mkDefault true;
    virt.enable = mkDefault true;
    flatpak.enable = mkDefault true;
    mysql.enable = mkDefault true;
    devtools.enable = mkDefault true;
    dirs.enable = mkDefault true;
    fancyfonts.enable = mkDefault true;
    vpn = {
      forti.enable = mkDefault true;
      wg.enable = mkDefault true;
      # wrong one
      openvpn.enable = mkDefault false;
      mullvad.enable = mkDefault false;
    };
  };
}
