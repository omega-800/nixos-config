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
    ./fs.nix
    ./pam.nix
    ./tty.nix
    ./fail2ban.nix
    ./proc.nix
  ];
  options.m.sec.enable = lib.mkEnableOption "enables security features";
}
