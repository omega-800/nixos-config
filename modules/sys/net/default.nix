{ lib, ... }: {
  imports = [ ./firewall.nix ./mac.nix ./net.nix ./sshd.nix ./ssh.nix ./vpn ];

  options.m.net.enable = lib.mkEnableOption "enables networking";
}
