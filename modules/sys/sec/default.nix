{ lib, ... }: {
  imports = [
./antivirus.nix
./apparmor.nix
./audit.nix
./doas.nix
./fail2ban.nix
./firejail.nix
./fs.nix
./gpg.nix
./isolate.nix
./kerberos.nix
./memory.nix
./pam.nix
./random.nix
./sops.nix
./systemd.nix
./tty.nix
./usbguard.nix
./wrappers.nix
  ];

  options.m.sec.enable = lib.mkEnableOption "enables security features";
}
