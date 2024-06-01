{ ... }: {
  imports = [
    ./doas.nix
    ./firejail.nix
    ./firewall.nix
    ./gpg.nix
    ./net.nix
    ./openvpn.nix
    ./sshd.nix
    ./systemd.nix
  ];
}
