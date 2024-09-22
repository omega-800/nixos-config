{ lib, ... }:
let inherit (lib) mkDefault;
in {
  imports = [ ./partials/gui/configuration.nix ];
  m = {
    net = {
      enable = mkDefault true;
      ssh.enable = mkDefault true;
      sshd.enable = mkDefault true;
      firewall.enable = mkDefault true;
      vpn = {
        forti.enable = mkDefault true;
        wg.enable = mkDefault true;
        # wrong one
        openvpn.enable = mkDefault false;
        mullvad.enable = mkDefault false;
      };
    };
    sec = { firejail.enable = mkDefault true; };
    dev = {
      enable = mkDefault true;
      docker.enable = mkDefault true;
      virt.enable = mkDefault true;
      tools.enable = mkDefault true;
      mysql.enable = mkDefault true;
    };
  };
}
