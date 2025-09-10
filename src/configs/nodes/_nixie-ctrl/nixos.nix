{ lib, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  m.os.boot.mode = "bios";
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  system.stateVersion = "23.11";
  # i see richard stallman's crying face before me
  nixpkgs.config = {
    allowUnfreePredicate = _: true;
    allowUnfree = true;
    allowBroken = true;
  };
  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb-6_0;
  };
}
