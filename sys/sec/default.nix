{ ... }: {
  imports = [
    ./doas.nix
    ./firejail.nix
    ./firewall.nix
    ./gpg.nix
    ./openvpn.nix
    ./sshd.nix
  ];
}
