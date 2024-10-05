{ lib, ... }: {
  imports = [
    ./doas.nix
    ./firejail.nix
    ./gpg.nix
    ./systemd.nix
    ./antivirus.nix
    ./sops.nix
    ./memory.nix
    ./apparmor.nix
    ./audit.nix
    ./isolate.nix
    ./kerberos.nix
    ./pam.nix
    ./tty.nix
    ./fail2ban.nix
    ./fs.nix
    ./usbguard.nix
    ./random.nix
  ];
  options.m.sec.enable = lib.mkEnableOption "enables security features";
}
