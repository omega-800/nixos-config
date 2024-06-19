{ ... }: {
  imports = [
    ./doas.nix
    ./firejail.nix
    ./firewall.nix
    ./gpg.nix
    ./net.nix
    ./sshd.nix
    ./systemd.nix
    ./antivirus.nix
    ./sops.nix
    ./mac.nix
    ./vpn
  ];
}
