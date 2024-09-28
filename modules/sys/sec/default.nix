{ lib, ... }: {
  imports = [
    ./doas.nix
    ./firejail.nix
    ./gpg.nix
    ./systemd.nix
    ./antivirus.nix
    ./sops.nix
  ];
  options.m.sec.enable = lib.mkEnableOption "enables security features";
}
