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
    ./vpn/wireguard.nix
    ./vpn/fortissl.nix
    ./vpn/openvpn.nix
    ./vpn/mullvad.nix
    ./mac.nix
  ];
}
