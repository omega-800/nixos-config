{ lib, pkgs, config, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  system.stateVersion = "23.11";
  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
    config.m.boot.bootMode = "bios";
  };
}
