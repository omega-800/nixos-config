{ lib, usr, ... }:
with lib; {
  imports = [
    # basically like work profile but with fun enabled
    ../work/home.nix
  ];

  # pkgs
  u = {
    media.enable = mkForce true;
    social.enable = mkForce true;
  };
}
